FROM ubuntu:24.04

LABEL maintainer="Péter Király <pkiraly@gwdg.de>"
LABEL description="Web interface of the quality assessment tool for Deutsche Digitale Bibliothek metadata."
# the Github repo labels
LABEL org.opencontainers.image.description="Web interface of the quality assessment tool for Deutsche Digitale Bibliothek metadata."
LABEL org.opencontainers.image.source=https://github.com/pkiraly/metadata-qa-ddb-web
LABEL org.opencontainers.image.licenses="GNU General Public License v3.0"

ARG SMARTY_VERSION=3.1.33

RUN apt-get update \
 && apt-get install -y --no-install-recommends software-properties-common \
 && apt-get install -y --no-install-recommends \
      # install basic OS tools
      apt-utils \
      unzip \
      nano \
      jq \
      curl \
      openssl \
      # install Java
      # openjdk-11-jre-headless \
      sqlite3 \
      less \
      apache2 \
      mysql-server \
      php php-mysql php-sqlite3 php-intl \
 && rm -rf /var/lib/apt/lists/* \
 && cd /var/www/html/ \
 && curl -s -L https://github.com/pkiraly/metadata-qa-ddb-web/archive/refs/heads/main.zip --output master.zip \
 && unzip -q master.zip \
 && rm master.zip \
 && mv metadata-qa-ddb-web-main metadata-qa-ddb \
 && cd metadata-qa-ddb \
 #
 # set configuration
 #
 && mv configuration.cnf.template configuration.cnf \
 && sed -i.bak 's,<path to input directory>,/opt/metadata-qa-ddb/input,' configuration.cnf \
 && sed -i.bak 's,<path to output directory>,/opt/metadata-qa-ddb/output,' configuration.cnf \
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
 # set apache
 #
 && sed -i.bak 's,</VirtualHost>,        RedirectMatch ^/$ /metadata-qa-ddb/\n        <Directory /var/www/html/metadata-qa-ddb>\n                Options Indexes FollowSymLinks MultiViews\n                AllowOverride All\n                Order allow\,deny\n                allow from all\n                DirectoryIndex index.php index.html\n        </Directory>\n</VirtualHost>,' /etc/apache2/sites-available/000-default.conf \
 #
 # set directories
 #
 && mkdir -p /opt/metadata-qa-ddb/input \
 && mkdir -p /opt/metadata-qa-ddb/output

WORKDIR /opt/metadata-qa-ddb
