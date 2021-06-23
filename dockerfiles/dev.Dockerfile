FROM python:3.9.5-slim

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Installs poetry and pip
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir poetry \
    && poetry config virtualenvs.create false --local

# Copy dependency definition to cache
COPY dockerfiles/dev.Dockerfile pyproject.toml* poetry.lock* /usr/src/app/

# Installs projects dependencies as a separate layer
RUN poetry export --dev --format requirements.txt --output requirements.txt \
    && pip install --require-hashes --no-cache-dir -r requirements.txt

COPY . /usr/src/app

EXPOSE 5000

CMD ["python", "azure_workflow/app.py"]