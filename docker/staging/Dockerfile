# syntax=docker/dockerfile:1

ARG BASE_IMAGE=python:3.12-slim
FROM ${BASE_IMAGE}

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Minimal runtime dependencies for staging
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt pyproject.toml poetry.lock package.json package-lock.json yarn.lock ./

RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

COPY . .

CMD ["sh", "-c", "echo 'Staging container is ready. Override CMD for your project.' && sleep infinity"]