FROM ubuntu:16.04
MAINTAINER Rafal Wesolowski <wesolowski@nexus-netsoft.com>

ADD .docker/scripts /opt/docker/scripts

RUN apt-get update && apt-get -y upgrade \
&& apt-get -y install supervisor openssh-server curl rsync vim git ant unzip sudo \
&& mkdir -p /var/run/sshd /var/log/supervisor \
&& echo 'root:docker' | chpasswd \
&& sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
&& adduser --disabled-password --home /var/www/ --gecos "" nexus \
&& echo 'nexus:nexus123' | chpasswd \
&& adduser nexus sudo \
&& adduser --disabled-password --home /var/www/ --gecos "" docker \
&& echo 'docker:docker' | chpasswd \
&& adduser docker sudo \
&& echo "nexus ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
&& echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
&& echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ADD .docker/supervisor /etc/supervisor/conf.d

RUN apt-get -y --force-yes install apache2 \
&& mkdir -p /var/lock/apache2 /var/run/apache2 \
&& rm -rf /etc/apache2/sites-enabled/* \
&& chmod +x /opt/docker/scripts/*.sh

ADD .docker/apache/vhost /etc/apache2/sites-enabled

RUN apt-get -y --force-yes install nodejs npm \
&& npm install -g grunt-cli \
&& apt-get -y install software-properties-common \
&& apt-get update && apt-get -y install python-software-properties \
&& a2enmod rewrite \
&& a2enmod ssl \
&& a2enmod vhost_alias \
&& apt-get -y clean \
&& chown -Rf www-data:www-data /var/ \
&& rm -rf /var/www/html \
&& ln -s /usr/bin/nodejs /usr/bin/node

ADD .docker/ssh /home/docker/.ssh/

# Change UIDs
RUN /bin/sh /opt/docker/scripts/change-uid.sh

EXPOSE 22 80 3000
CMD ["supervisord", "-n"]