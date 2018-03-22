#! /bin/sh
cd /home/app/ezidpums
bundle exec rails db:create RAILS_ENV=production
bundle exec rails db:migrate RAILS_ENV=production
bundle exec rails db:seed RAILS_ENV=production
RAILS_ENV=production bundle exec rails runner 'ActiveLdap::Populate.ensure_base(Account, ou_base_class: ActiveLdap::Base)'
