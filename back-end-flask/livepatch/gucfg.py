bind = '0.0.0.0:80'

workers = 3

accesslog = '/var/log/gunicorn.access.log'

errorlog = '/var/log/gunicorn.error.log'

loglevel = 'warning'

reload = True