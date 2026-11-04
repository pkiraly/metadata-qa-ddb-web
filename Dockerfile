FROM php:8.3-apache

LABEL maintainer="Péter Király <pkiraly@gwdg.de>"
LABEL description="A web interface of quality assessment tool for Deutsche Digitale Bibliothek metadata."
# the Github repo labels
LABEL org.opencontainers.image.description="A web interface of quality assessment tool for Deutsche Digitale Bibliothek metadata."
LABEL org.opencontainers.image.source=https://github.com/pkiraly/metadata-qa-ddb-web
LABEL org.opencontainers.image.licenses="GNU General Public License v3.0"

# Patch drift is intentional; API-breaking majors stay opt-in.
ARG SMARTY_MAJOR=4
ARG DOMPDF_MAJOR=3

# Patch installed OS packages too; apt-get install alone leaves old baggage.
RUN apt-get update \
 && apt-get upgrade -y \
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
      # php-raphf \
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
 # Stable tags only; numeric SemVer keeps .10 ahead of .9.
 #
 && cd libs/ \
 && curl -fsSL https://repo.packagist.org/p2/smarty/smarty.json --output /tmp/smarty.json \
 && SMARTY_VERSION="$(jq -er --arg major "$SMARTY_MAJOR" '.packages["smarty/smarty"] | map(.version | ltrimstr("v") | select(startswith($major + ".") and test("^[0-9]+\\.[0-9]+\\.[0-9]+$"))) | max_by(split(".") | map(tonumber))' /tmp/smarty.json)" \
 && curl -fsSL https://github.com/smarty-php/smarty/archive/v${SMARTY_VERSION}.zip --output v$SMARTY_VERSION.zip \
 && unzip -oq v${SMARTY_VERSION}.zip \
 # Keep the loader path stable while releases move on.
 && mv smarty-${SMARTY_VERSION} smarty \
 && rm v${SMARTY_VERSION}.zip /tmp/smarty.json \
 && mkdir -p _smarty/templates_c \
 && chmod a+w -R _smarty/templates_c/ \
 #
 # Use Dompdf's bundled release ZIP, including its dependency tree.
 #
 && curl -fsSL https://repo.packagist.org/p2/dompdf/dompdf.json --output /tmp/dompdf.json \
 && DOMPDF_VERSION="$(jq -er --arg major "$DOMPDF_MAJOR" '.packages["dompdf/dompdf"] | map(.version | ltrimstr("v") | select(startswith($major + ".") and test("^[0-9]+\\.[0-9]+\\.[0-9]+$"))) | max_by(split(".") | map(tonumber))' /tmp/dompdf.json)" \
 && curl -fsSL https://github.com/dompdf/dompdf/releases/download/v${DOMPDF_VERSION}/dompdf-${DOMPDF_VERSION}.zip \
    --output dompdf-${DOMPDF_VERSION}.zip \
 && unzip -oq dompdf-${DOMPDF_VERSION}.zip \
 && rm dompdf-${DOMPDF_VERSION}.zip /tmp/dompdf.json \
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
