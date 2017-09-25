#!/bin/bash
python3 manage.py migrate                  # Apply database migrations
python3 manage.py collectstatic --noinput  # Collect static files

# Prepare log files and start outputting logs to stdout
touch /srv/logs/gunicorn.log
touch /srv/logs/access.log
tail -n 0 -f /srv/logs/*.log &

# Start Gunicorn processes
echo Starting Gunicorn.
exec gunicorn reconstruye_mx.wsgi:application \
    --env DJANGO_SETTINGS_MODULE='reconstruye_mx.settings' \
    --name reconstruye_mx \
    --bind 0.0.0.0:8000 \
    --timeout 120 \
    --workers 3 \
    --reload \
    --log-level=info \
    --log-file=/srv/logs/gunicorn.log \
    --access-logfile=/srv/logs/access.log \
    "$@"