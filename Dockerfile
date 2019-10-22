FROM centos:centos7

MAINTAINER Aitor Martin <aitor@martinh.es>

ENV HOME /root

ADD nginx.repo /etc/yum.repos.d/nginx.repo

ADD init.sh /usr/bin/init.sh

RUN yum clean all &&  yum install -y epel-release gcc hg nginx mariadb-devel openldap-devel libjpeg-devel zlib-devel python3-setuptools python3-devel python36-ldap3 git &&  rm /etc/nginx/conf.d/* && easy_install-3.6 virtualenv uwsgi

ADD nginx.conf /etc/nginx/nginx.conf

ADD nginx-syslog.conf /etc/nginx/nginx-syslog.conf

CMD /usr/bin/init.sh

EXPOSE 80 443

VOLUME ["/var/www"]
