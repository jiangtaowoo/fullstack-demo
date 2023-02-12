#!/usr/bin/bash
#pwd
#cp runserver.sh /livepatch/runserver.sh
#cp main.py /livepatch/runserver.sh
#tail -f /dev/null
gunicorn -c /livepatch/gucfg.py livepatch.main:app