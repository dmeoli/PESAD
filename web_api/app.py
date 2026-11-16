#!/usr/bin/env python3
# coding=utf-8

"""
PESAD web API.

A stateless HTTP front-end over the engine layer (../pesad_engine), for the
expert-system section of the author's site. Every request carries the whole
consultation so far:

    POST /step  {"lang": "en" | "it", "backend": "cf", "answers": ["<value>", ...],
                 "chapters": [...]}

and the server starts a fresh Prolog session, replays the answers and returns
the screen reached: the next question, or the result of the investigation.
The question after the age band asks the area (chapter) to investigate;
"chapters", when given, answers it in advance.

    POST /evaluate  {"lang", "backend", "age" | "age_band", "facts": [...],
                     "goals" | "chapters"}

evaluates the goals without questions, on answers and test results given at
once, and returns for every goal its status, its certainty bounds, the
criteria met, not met or unknown, the missing data, the proof tree and the
differentials (see README.md); GET /findings lists what "facts" accepts.
Nothing is stored and the answers are never logged.

Author: Donato Meoli
"""

import os
import sys
from contextlib import asynccontextmanager
from typing import Annotated, Literal

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import (BaseModel, ConfigDict, Field, StrictBool, StrictFloat,
                      StrictInt, StringConstraints)

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from pesad_engine import METHODS, Engine, InvalidAnswer  # noqa: E402

MAX_ANSWERS = 1000       # an investigation of all the areas takes about 370 answers
MAX_FACTS = 500
MAX_BODY_BYTES = 64 * 1024
ORIGINS = ["https://dmeoli.github.io", "http://localhost:8780"]


Id = Annotated[str, StringConstraints(max_length=128, pattern=r"^[a-z0-9_]+$")]
CHAPTERS = Literal["neurodevelopmental", "anxiety", "obsessive_compulsive", "trauma"]


class Step(BaseModel):
    lang: Literal["en", "it"]
    backend: Literal[tuple(METHODS)] = "cf"
    answers: list[Annotated[str, StringConstraints(max_length=64)]] = Field(
        default_factory=list, max_length=MAX_ANSWERS)
    chapters: list[CHAPTERS] | None = Field(default=None, min_length=1, max_length=4)


class Fact(BaseModel):
    """One fact: exactly one of item, choice, number, finding, and its value."""
    model_config = ConfigDict(extra="forbid")
    item: Id | None = None
    choice: Id | None = None
    number: Id | None = None
    finding: Id | None = None
    value: StrictBool | StrictInt | StrictFloat | Id
    certainty: float | None = Field(default=None, ge=0, le=1)


class Evaluate(BaseModel):
    model_config = ConfigDict(extra="forbid")
    lang: Literal["en", "it"] = "en"
    backend: Literal[tuple(METHODS)] = "cf"
    age: float | None = Field(default=None, ge=0, le=120)
    age_band: Literal["preschool", "child", "adolescent", "adult"] | None = None
    facts: list[Fact] = Field(default_factory=list, max_length=MAX_FACTS)
    goals: list[Id] | None = Field(default=None, max_length=200)
    chapters: list[CHAPTERS] | None = Field(default=None, max_length=4)


@asynccontextmanager
async def lifespan(app):
    app.state.engine = Engine()
    await app.state.engine.start()
    app.state.disclaimer = {lang: await app.state.engine.label(lang, "disclaimer")
                            for lang in ("en", "it")}
    app.state.findings = await app.state.engine.findings()
    yield
    await app.state.engine.stop()


app = FastAPI(title="PESAD", lifespan=lifespan, docs_url=None, redoc_url=None)
app.add_middleware(CORSMiddleware, allow_origins=ORIGINS,
                   allow_methods=["GET", "POST"], allow_headers=["Content-Type"])


@app.middleware("http")
async def limit_body(request: Request, call_next):
    """Reject bodies over MAX_BODY_BYTES before they are read."""
    if request.method == "POST":
        length = request.headers.get("content-length", "")
        if not length.isdigit():
            return JSONResponse({"detail": "length required"}, status_code=411)
        if int(length) > MAX_BODY_BYTES:
            return JSONResponse({"detail": "request body too large"},
                                status_code=413)
    return await call_next(request)


@app.exception_handler(RequestValidationError)
async def bad_request(request: Request, exc: RequestValidationError):
    # A generic message: the error details would echo the answers back.
    return JSONResponse({"detail": "invalid request"}, status_code=400)


@app.exception_handler(InvalidAnswer)
async def invalid_answer(request: Request, exc: InvalidAnswer):
    return JSONResponse({"detail": "invalid answer", "index": exc.index},
                        status_code=400)


@app.get("/")
async def health():
    return {"ok": True}


@app.post("/step")
async def step(body: Step, request: Request):
    screen = await request.app.state.engine.consult(
        body.lang, body.answers, body.backend, body.chapters)
    reply = web_screen(screen, len(body.answers))
    if reply["kind"] == "question" and reply["step"] == 0:
        reply["disclaimer"] = request.app.state.disclaimer[body.lang]
    return reply


@app.post("/evaluate")
async def evaluate(body: Evaluate, request: Request):
    reply = await request.app.state.engine.evaluate(body.model_dump(exclude_none=True))
    if "error" in reply:
        return JSONResponse({"detail": reply["error"], "index": reply["index"]},
                            status_code=400)
    return reply


@app.get("/findings")
async def findings(request: Request):
    return request.app.state.findings


def web_screen(screen, step):
    """The JSON of an engine screen: a question or the final result."""
    topic = screen.topic or {}
    kind = topic.get("type")
    if kind == "diagnosis":
        items = [{"id": g["id"], "name": g["name"], "detail": g["tree"],
                  "score": f"{g['certainty']}%"}
                 for g in topic["goals"] if g["certainty"] > 0]
        return {"kind": "result", "title": topic["title"], "items": items,
                "text": topic["ranking"] if items else topic["none"],
                "disclaimer": topic["disclaimer"], "step": step}
    if kind in ("criterion", "certainty", "choice", "number"):
        qid = topic["id"] + (".certainty" if kind == "certainty" else "")
        return {"kind": "question", "id": qid, "text": topic["text"],
                "help": topic.get("help"), "why": topic.get("why"),
                "options": screen.options(), "multi": False, "step": step}
    raise RuntimeError(f"unexpected engine screen {screen.kind!r}")
