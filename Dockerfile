ARG VARIANT="3.10-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

ENV PYTHONUNBUFFERED 1

WORKDIR /app

EXPOSE 8000

COPY requirements.txt .
COPY requirements.dev.txt .

ARG DEV=false

RUN apt-get update && \
    apt-get -y install sudo

RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    if [ $DEV = "true" ]; \
        then pip install -r requirements.dev.txt ; \
    fi

RUN adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    usermod -aG sudo django-user

USER django-user
