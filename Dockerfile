FROM python:3.9-alpine3.13

LABEL maintainer "countdemoney"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app

WORKDIR /app 
EXPOSE 8000

RUN python -m venv /py &&\
    /py/bin/pip install --upgrade pip &&\
    apk add --update --no-cache postgresql-client &&\
    apk add --update --no-cache --virtual .temp-deps build-base postgresql-dev musl-dev &&\
    /py/bin/pip install -r /requirements.txt &&\
    apk del .temp-deps &&\
    adduser --disabled-password --no-create-home app &&\
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    chown -R app:app /vol && \
    chmod -R 775 /vol 


ENV PATH="/py/bin:$PATH" 

USER app