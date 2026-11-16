# PESAD web API: SWI-Prolog engine + Python (FastAPI) front-end, for Cloud Run.
# Build from the repository root: docker build -f web_api/Dockerfile .
FROM swipl:latest

RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-venv \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY prolog /app/prolog
COPY pesad_engine /app/pesad_engine
COPY web_api /app/web_api

RUN python3 -m venv /app/.venv \
 && /app/.venv/bin/pip install --no-cache-dir -r web_api/requirements.txt

# Cloud Run sets PORT; no access log, the answers are never logged anyway.
ENV PORT=8080
CMD ["sh", "-c", "exec /app/.venv/bin/uvicorn --app-dir web_api app:app --host 0.0.0.0 --port $PORT --no-access-log"]
