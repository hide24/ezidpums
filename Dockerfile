FROM phusion/passenger-ruby27

LABEL maintainer="Hidetoshi Yoshimoto <hidetoshi.yoshimoto@gmail.com>"

# Passenger app container cannot read shell variables.
# It should be set by 'passenger_env_var' setting on nginx config.
# See nginx_webapp.conf
# This Dockerfile replace __VARS__ with Docker ARGs.
ARG LDAP_BASE_DN
ARG LDAP_BIND_DN
ARG LDAP_BIND_PASSWORD
ARG MYSQL_ROOT_PASSWORD
ARG IDP_HOST_NAME
ARG IDP_SCOPE
ARG JETTY_KEYSTORE_PASSWORD

# ARGs values copy to shell variables.
# rails command will use it.
ENV LDAP_BASE_DN=$LDAP_BASE_DN \
    LDAP_BIND_DN=$LDAP_BIND_DN \
    LDAP_BIND_PASSWORD=$LDAP_BIND_PASSWORD \
    MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    IDP_HOST_NAME=$IDP_HOST_NAME \
    IDP_SCOPE=$IDP_SCOPE \
    JETTY_KEYSTORE_PASSWORD=$JETTY_KEYSTORE_PASSWORD

ENV APP_ROOT=/home/app/ezidpums
WORKDIR $APP_ROOT

ENV HOME=/root
CMD ["/sbin/my_init"]

# Fix bundler location so that a stray .bundle/config copied from the host is ignored.
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle

# The base image ships:
#  - a NodeSource "node_18.x" repo that no longer exists (404)
#  - a Passenger repo whose signing key has been rotated (NO_PUBKEY D870AB033FB45BD1)
# Remove both BEFORE the first apt-get update, import the new key, then re-add Passenger.
# Node.js already installed in the image keeps working.
RUN grep -l -r nodesource        /etc/apt/sources.list.d/ | xargs -r rm -f && \
    grep -l -r phusionpassenger  /etc/apt/sources.list.d/ | xargs -r rm -f && \
    apt-get update && \
    apt-get install -y --no-install-recommends gnupg ca-certificates curl && \
    curl -fsSL https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key-2025.txt | gpg --dearmor -o /etc/apt/trusted.gpg.d/phusion.gpg && \
    . /etc/os-release && \
    echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/passenger.list

RUN apt-get update && \
    (command -v node >/dev/null || apt-get install -y nodejs --no-install-recommends) && \
    apt-get install -y mysql-client \
                       postgresql-client \
                       sqlite3 \
                       ldap-utils \
                       libldap2-dev \
                       libyaml-dev \
                       libsqlite3-dev \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock $APP_ROOT/

RUN gem install bundler -v 2.4.10 && \
    bundle _2.4.10_ config set --global build.nokogiri --use-system-libraries && \
    bundle _2.4.10_ config set --global jobs 4 && \
    bundle _2.4.10_ install

RUN rm -f /etc/service/nginx/down && \
    rm -f /etc/nginx/sites-enabled/default

COPY . $APP_ROOT

# If Gemfile.lock was overwritten by COPY ., install whatever is missing.
RUN bundle _2.4.10_ check || bundle _2.4.10_ install

RUN chown -R app:app $APP_ROOT

# Fail the build if `rails secret` fails (backticks would silently produce an empty value).
RUN SECRET_KEY_BASE=$(bundle _2.4.10_ exec rails secret) && \
    test -n "$SECRET_KEY_BASE" && \
    sed -e "s/__secret_key_base__/$SECRET_KEY_BASE/" $APP_ROOT/nginx_webapp.conf > /etc/nginx/sites-enabled/webapp.conf && \
    sed -i -e "s/__ldap_base_dn__/$LDAP_BASE_DN/" /etc/nginx/sites-enabled/webapp.conf && \
    sed -i -e "s/__ldap_bind_dn__/$LDAP_BIND_DN/" /etc/nginx/sites-enabled/webapp.conf && \
    sed -i -e "s/__ldap_bind_password__/$LDAP_BIND_PASSWORD/" /etc/nginx/sites-enabled/webapp.conf && \
    sed -i -e "s/__mysql_root_password__/$MYSQL_ROOT_PASSWORD/" /etc/nginx/sites-enabled/webapp.conf && \
    sed -i -e "s/__idp_host_name__/$IDP_HOST_NAME/" /etc/nginx/sites-enabled/webapp.conf && \
    sed -i -e "s/__idp_socpe__/$IDP_SCOPE/" /etc/nginx/sites-enabled/webapp.conf && \
    sed -i -e "s/__jetty_keystore_password__/$JETTY_KEYSTORE_PASSWORD/" /etc/nginx/sites-enabled/webapp.conf

RUN bundle _2.4.10_ exec rails assets:precompile
