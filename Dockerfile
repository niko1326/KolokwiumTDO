FROM python:3.12-slim

# Do not write .pyc files and don't buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
		PYTHONUNBUFFERED=1

WORKDIR /app

# Create non-root user
RUN groupadd -r app && useradd -r -g app -d /app -s /sbin/nologin app

# Copy requirements first to leverage Docker layer cache
COPY --chown=app:app requirements.txt /app/

# Upgrade packaging tools, install runtime deps without cache
RUN python -m pip install --upgrade pip setuptools wheel && \
		pip install --no-cache-dir -r /app/requirements.txt

# Copy application code
COPY --chown=app:app . /app/

# Run as non-root user
USER app

EXPOSE 8000

# Basic healthcheck for container orchestrators
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
	CMD curl -f http://127.0.0.1:8000/health || exit 1

# Start WSGI server
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app.main:app"]

