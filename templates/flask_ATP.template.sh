export LD_LIBRARY_PATH=/usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib
cd /tmp
gunicorn --bind 0.0.0.0:80 flask_ATP:app 