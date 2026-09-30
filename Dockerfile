FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install the published TeraBox Gateway package
RUN pip install --no-cache-dir \
    "terabox-gateway==2.0.2"

ENV PORT=8080

EXPOSE 8080

HEALTHCHECK --interval=30s \
    --timeout=10s \
    --start-period=30s \
    --retries=3 \
    CMD curl -fsS \
    "http://127.0.0.1:${PORT}/health" || exit 1

CMD ["sh", "-c", "terabox-gateway --host 0.0.0.0 --port ${PORT}"]
