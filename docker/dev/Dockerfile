# syntax=docker/dockerfile:1

ARG BASE_IMAGE=python:3.12-slim
FROM ${BASE_IMAGE}

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Tools useful in a dev container
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash \
       curl \
       git \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency manifests first to benefit from build cache.
# Adapt these files to your stack.
COPY requirements.txt pyproject.toml poetry.lock package.json package-lock.json yarn.lock ./

# Install dependencies only if the files exist.
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Copy source code
COPY . .

# Default command is intentionally simple.
# Replace it with your app command if needed.
CMD ["sh", "-c", "echo 'Dev container is ready. Override CMD for your project.' && sleep infinity"]