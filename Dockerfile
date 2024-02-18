# Export pip dependencies
FROM python:3.11-slim AS poetry

RUN pip install poetry
COPY poetry.lock pyproject.toml /
RUN poetry export -f requirements.txt -o /requirements.txt

# Copy source code
FROM scratch as source

WORKDIR /
COPY marzbanbot /marzbanbot


# Final image
FROM python:3.11-slim AS final

WORKDIR /app

COPY --from=poetry /requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
COPY --from=source / /app

CMD ["python", "-m", "marzbanbot"]
