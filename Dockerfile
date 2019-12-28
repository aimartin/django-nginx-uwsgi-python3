#Python Compiling Stage
FROM centos:centos7 AS python-compilation

WORKDIR /usr/src

RUN yum clean all &&  yum install -y epel-release gcc make openssl-devel bzip2-devel libffi-devel wget && wget -q https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz -P /usr/src/ && tar xf /usr/src/Python-3.7.6.tgz -C /usr/src/ && cd /usr/src/Python-3.7.6 && ./configure --enable-optimizations && make


# Final Stage
FROM centos:centos7

MAINTAINER Aitor Martin <aitor@martinh.es>

ENV HOME /root

ADD nginx.repo /etc/yum.repos.d/nginx.repo

ADD init.sh /usr/bin/init.sh

COPY --from=python-compilation /usr/src/Python-3.7.6 /usr/src/Python-3.7.6

RUN yum clean all &&  yum install -y epel-release gcc openssl-devel bzip2-devel libffi-devel nginx mariadb-devel openldap-devel libjpeg-devel zlib-devel wget git && rm /etc/nginx/conf.d/* && cd /usr/src/Python-3.7.6 && make install && pip3 install --upgrade pip && pip3 install virtualenv uwsgi && rm -rf /usr/src/Python-3.7.6 && yum clean all

ADD nginx.conf /etc/nginx/nginx.conf

ADD nginx-syslog.conf /etc/nginx/nginx-syslog.conf

CMD /usr/bin/init.sh

EXPOSE 80 443

VOLUME ["/var/www"]
