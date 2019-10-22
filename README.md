**Description:**
Official Centos 7 based Image with:
* EPEL
* Nginx 1.8.0 (Official NGINX repo)
* wsgi 2.0.18
* virtualenv 16.7.6
* python 3.6.8
* setuptools 39.2.0

Extra libs installed for Django:
* libjpeg-turbo-devel-1.2.90-8
* zlib-devel-1.2.7-18
* openldap-2.4.44-21
* mariadb-devel 5.5.64-1
* python-devel-3.6.8-10

**Usage**
Run the image and mount your webapp folder in /var/www. Expose the desired 80/443 port for Nginx.
If you want to use an external Syslog server, run docker with --add-host="syslog.server:<IP>"

**WebApp Folder**
* <VirtualEnv Name> -> VirtualEnv with your python dependencies
* <DJango App Folder> -> Folder with your Django App
* nginx -> Folder that contains the nginx config and logs
⋅⋅* nginx/conf.d -> Folder that contains the VirtualHost for Nginx. Put your site.conf file here.
⋅⋅* nginx/log -> Folder that will contain nginx logs (configure this in site.conf file)
* uwsgi -> Folder that contains the uwsgi configuration. UWSGI will run in emperor mode and will look for ini files here

**USGI Example File - Adapt it for your use!:**
```
[uwsgi]

# Django-related settings #
# the base directory (full path)
chdir           = /var/www/<DJango App Folder>
# Django's wsgi file
module          = <DjangoAppName>.wsgi
# the virtualenv (full path)
home            = /var/www/<VirtualEnv Name>

# process-related settings #
# master
master          = true
# maximum number of worker processes
processes       = 10
# the socket (use the full path to be safe
socket          = /var/www/nginx/uwsgi.sock
#Max request per child
max-request	= 5000
#Daemon
daemonize=/var/www/nginx/log/uwsgi.log
# clear environment on exit
vacuum          = true
```
**Nginx config file - Adapt it for your use!:**
```
upstream django {
    server unix:///var/www/nginx/uwsgi.sock; # for a file socket
}

# configuration of the server
server {
    # the port your site will be served on
    listen      80;
    # the domain name it will serve for
    server_name <Your Server Name>; # substitute your machine's IP address or FQDN
    charset     utf-8;

    # max upload size
    client_max_body_size 75M;   # adjust to taste

    # Django media
    location /media  {
        alias /var/www/<DJango App Folder>/media;  # your Django project's media files - amend as required
    }

    location /static {
        alias /var/www/<DJango App Folder>/static; # your Django project's static files - amend as required
    }

    # Finally, send all non-media requests to the Django server.
    location / {
        uwsgi_pass  django;
        include     /etc/nginx/uwsgi_params; # the uwsgi_params file you installed
    }
}
```
