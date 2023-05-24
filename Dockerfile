# Image 
FROM python:3.11-alpine

# Environment variables

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFER 1

# Copy requirements
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# work directory
WORKDIR /app

# copy the django project to /app dir
COPY ./app /app

# expose port 8000
EXPOSE 8080

# install requirements
ARG DEV=false
RUN python -m venv /env && \
    /env/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /env/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ];\
        then /env/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --gecos "" \
        --home /app \
        django-user && \
        chown -R django-user /app

ENV PATH="/env/bin:$PATH"

USER django-user