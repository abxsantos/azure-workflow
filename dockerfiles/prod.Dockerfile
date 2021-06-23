FROM python:3.9.5-slim

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN pip3 install --no-cache-dir poetry

# Copy dependency definition to cache
COPY poetry.lock pyproject.toml /usr/src/app/

# Installs projects dependencies as a separate layer
RUN poetry export -f requirements.txt -o requirements.txt \
    && pip uninstall --yes poetry \
    && pip install --require-hashes --no-cache-dir -r requirements.txt

COPY . /usr/src/app

EXPOSE 5000

CMD ["bash", "-c", "'scripts/start.sh'"]