FROM phusion/passenger-ruby25

ENV APP_ROOT /home/app/ezidpums
WORKDIR $APP_ROOT

ENV HOME /root
CMD ["/sbin/my_init"]

RUN apt-get update && \
    apt-get install -y nodejs \
                       mysql-client \
                       postgresql-client \
                       sqlite3 \
                       ldap-utils \
                       libldap2-dev \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

# Default version of RubyGems(2.7.3) does not work with passenger! It should be update.
RUN \
  gem update --system && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  rm -rf ~/.gem

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
COPY --chown=app:app . $APP_ROOT
RUN echo s/__secret_key_base__/`bundle exec rails secret`/ > secret_rep && \
    sed -f secret_rep $APP_ROOT/nginx_webapp.conf > /etc/nginx/sites-enabled/webapp.conf
RUN bundle exec rails assets:precompile
