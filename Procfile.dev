madiy-platform: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
madiy-platform-worker: bundle exec good_job start
release: bundle exec rake db:migrate
