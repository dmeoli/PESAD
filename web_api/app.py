#!/usr/bin/env python3
# coding=utf-8

"""
PESAD web API.

A stateless HTTP front-end over the engine layer (../pesad_engine), for the
expert-system section of the author's site. Every request carries the whole
consultation so far:

    POST /step  {"lang": "en" | "it", "backend": "cf", "answers": ["<value>", ...]}

and the server starts a fresh Prolog session, replays the answers and returns
the screen reached: the next question, or the result of the investigation.
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
from pydantic import BaseModel, Field, StringConstraints

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from pesad_engine import METHODS, Engine, InvalidAnswer  # noqa: E402

MAX_ANSWERS = 1000       # a complete investigation takes about 260 answers
MAX_BODY_BYTES = 64 * 1024
ORIGINS = ["https://dmeoli.github.io", "http://localhost:8780"]


class Step(BaseModel):
    lang: Literal["en", "it"]
    backend: Literal[tuple(METHODS)] = "cf"
    answers: list[Annotated[str, StringConstraints(max_length=64)]] = Field(
        default_factory=list, max_length=MAX_ANSWERS)


@asynccontextmanager
async def lifespan(app):
    app.state.engine = Engine()
    await app.state.engine.start()
    app.state.disclaimer = {lang: await app.state.engine.label(lang, "disclaimer")
                            for lang in ("en", "it")}
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
    screen = await request.app.state.engine.consult(body.lang, body.answers, body.backend)
    reply = web_screen(screen, len(body.answers))
    if reply["kind"] == "question" and reply["step"] == 0:
        reply["disclaimer"] = request.app.state.disclaimer[body.lang]
    return reply


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
