# syntax=docker/dockerfile:1

ARG BASE_IMAGE=python:3.12-slim
FROM ${BASE_IMAGE} AS base

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt pyproject.toml poetry.lock package.json package-lock.json yarn.lock ./

RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

COPY . .

# Use a non-root user in production
RUN useradd --create-home --shell /usr/sbin/nologin appuser \
    && chown -R appuser:appuser /app

USER appuser

CMD ["sh", "-c", "echo 'Production container is ready. Override CMD for your project.' && sleep infinity"]