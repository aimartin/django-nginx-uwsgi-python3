#!/bin/bash

SYSLOG=`grep -c syslog.server /etc/hosts`
chown -R nginx.nginx /var/www
if [ ${SYSLOG} -gt 0 ]; then
        cp /etc/nginx/nginx-syslog.conf /etc/nginx/nginx.conf
	uwsgi --emperor /var/www/uwsgi/ --uid nginx --gid nginx --logger rsyslog:syslog.server:514,uwsgi --daemonize /var/www/nginx/log/uwsgi-daemon.log
else
	uwsgi --emperor /var/www/uwsgi/ --uid nginx --gid nginx --daemonize /var/www/nginx/log/uwsgi-daemon.log
fi
nginx
