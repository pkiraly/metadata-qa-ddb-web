FROM php:8.1-apache

LABEL maintainer="Péter Király <pkiraly@gwdg.de>"
LABEL description="A metadata quality assessment tool for Deutsche Digitale Bibliothek."

ARG SMARTY_VERSION=3.1.33
ARG DOMPDF_VERSION=3.1.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      # install basic OS tools
      apt-utils \
      unzip \
      nano \
      jq \
      curl \
      openssl \
      sqlite3 \
      less \
      libyaml-dev libicu-dev libzip-dev \
      default-mysql-client \
      php-raphf \
      # php php-mysql php-sqlite3 php-intl \
     && pecl install yaml \
     && docker-php-ext-configure intl \
     && docker-php-ext-install gettext zip intl \
     && docker-php-ext-install pdo pdo_mysql \
     && docker-php-ext-enable yaml intl \
 && rm -rf /var/lib/apt/lists/*

COPY . /var/www/html/
WORKDIR /var/www/html

RUN \
 #
 # set configuration
 #
 mv configuration.cnf.template configuration.cnf \
 && sed -i.bak 's,<path to input directory>,/opt/metadata-qa-ddb/input,' configuration.cnf \
 && sed -i.bak 's,<path to output directory>,/opt/metadata-qa-ddb/output,' configuration.cnf \
 && sed -i.bak 's,<MySQL database host>,mqaf-ddb-db,' configuration.cnf \
 && sed -i.bak 's,<MySQL database name>,ddb,' configuration.cnf \
 && sed -i.bak 's,<MySQL user name>,ddb,' configuration.cnf \
 && sed -i.bak 's,<MySQL password>,ddb,' configuration.cnf \
 #
 # set smarty
 #
 && cd libs/ \
 && curl -s -L https://github.com/smarty-php/smarty/archive/v${SMARTY_VERSION}.zip --output v$SMARTY_VERSION.zip \
 && unzip -q v${SMARTY_VERSION}.zip \
 && rm v${SMARTY_VERSION}.zip \
 && mkdir -p _smarty/templates_c \
 && chmod a+w -R _smarty/templates_c/ \
 #
 # set dompdf (from https://github.com/dompdf/dompdf)
 #
 && curl -s -L https://github.com/dompdf/dompdf/releases/download/v${DOMPDF_VERSION}/dompdf-${DOMPDF_VERSION}.zip \
    --output dompdf-${DOMPDF_VERSION}.zip \
 && unzip dompdf-${DOMPDF_VERSION}.zip \
 && rm dompdf-${DOMPDF_VERSION}.zip \
 #
 # set apache
 #
 && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
 && a2disconf other-vhosts-access-log \
 && sed -i.bak 's,</VirtualHost>,        <Directory /var/www/html>\n                Options Indexes FollowSymLinks MultiViews\n                AllowOverride All\n                Order allow\,deny\n                allow from all\n                DirectoryIndex index.php index.html\n        </Directory>\n</VirtualHost>,' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's|^\s*ErrorLog .*|\tErrorLog /proc/self/fd/2|' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's|^\s*CustomLog .*|\tCustomLog /proc/self/fd/1 combined|' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's|^\s*TransferLog .*|\tCustomLog /proc/self/fd/1 combined|' /etc/apache2/sites-available/000-default.conf \
 #
 # set directories
 #
 && mkdir -p /opt/metadata-qa-ddb/input \
 && mkdir -p /opt/metadata-qa-ddb/output \
 && chgrp -R 0 /var/www/html /tmp /opt/metadata-qa-ddb \
 && chmod -R g=u /var/www/html /tmp /opt/metadata-qa-ddb

#
# set php.ini
#
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
 && rm "$PHP_INI_DIR/php.ini-development" \
 && sed -i.bak 's,;error_log = php_errors.log,error_log = /proc/self/fd/2,' "$PHP_INI_DIR/php.ini"

WORKDIR /opt/metadata-qa-ddb

CMD ["apache2-foreground"]
EXPOSE 8080
