FROM centos:centos7

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="PHP-FRPM Docker Image" \
    org.label-schema.vendor="AlleoTech" \
    org.label-schema.livence="MIT" \
    org.label-schema.build-data="2019042801"

MAINTAINER AlleoTech <admin@alleo.tech>

ARG PHP_VETRSION=71

# Enable Networking
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Install EPEL & REMI
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable epel \
    && yum-config-manager --enable remi-php${PHP_VETRSION}


# Install PHP and Tools 
RUN yum -y install --setopt=tsflags=nodocs git \
    openssh-clients \
    php-cli \
    php-common \
    php-gd \
    php-intl \
    php-json \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-opcache \
    php-pdo \
    php-pecl-apcu \
    php-process \
    php-soap \
    php-xml \
    php-xmlrpc \
    php-fpm \
    && yum clean all \
    && rm -rf /var/cache/yum

# Configure PHP
RUN sed -i -e 's~^;date.timezone =$~date.timezone = UTC~g' /etc/php.ini
RUN mkdir /run/php-fpm

COPY etc/php-fpm.d/www.pool /etc/php-fpm.d/www.conf
COPY run.sh /usr/local/bin/run.sh

EXPOSE 9000

CMD ["/usr/local/bin/run.sh"]
