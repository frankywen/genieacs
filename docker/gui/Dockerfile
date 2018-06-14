FROM ruby:2.3

LABEL author="qm-wen<qm-wen@mygzb.com>"

ENV APP_HOME /app/genieacs-gui

RUN mkdir $APP_HOME -p

WORKDIR $APP_HOME

ADD ./Gemfile $APP_HOME/Gemfile
ADD ./Gemfile.lock $APP_HOME/Gemfile.lock
ADD ./Rakefile $APP_HOME/Rakefile
ADD ./config $APP_HOME/config
# ADD ./config/application.rb $APP_HOME/config/application.rb
# ADD ./config/boot.rb $APP_HOME/config/boot.rb
# ADD . $APP_HOME

# RUN echo 'for f in /app/genieacs-gui/config/*-sample.yml; do mv "$f" "${f/-sample.yml/.yml}"; done' | bash -

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
	apt-get install -y nodejs && \
	cd /app/genieacs-gui && \
	RAILS_ENV=production bundle 
	# && \
	# RAILS_ENV=production bundle exec rake assets:precompile

# RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
# 	apt-get install -y nodejs && \
# 	cd /app/genieacs-gui && \
# 	RAILS_ENV=production bundle && \
# 	RAILS_ENV=production bundle exec rake assets:precompile

# RUN if [ -f /app/genieacs-gui/tmp/pids/server.pid ]; then rm /app/genieacs-gui/tmp/pids/server.pid; fi

# RUN mv /app/genieacs-gui/config/graphs-sample.json.erb /app/genieacs-gui/config/graphs.json.erb

EXPOSE 3000

CMD ["bash", "./start.sh"]
# CMD ["/app/genieacs-gui/bin/rails", "server"]