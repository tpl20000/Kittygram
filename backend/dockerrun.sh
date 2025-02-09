#!/bin/sh

python manage.py migrate
python manage.py collectstatic

cp -r /app/static/. /backend_static/static/

gunicorn --bind 0.0.0.0:8000 kittygram_backend.wsgi