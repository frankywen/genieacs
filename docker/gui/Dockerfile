FROM ruby:2.3

LABEL author="qm-wen<qm-wen@mygzb.com>"

ENV APP_HOME /app/genieacs-gui
RUN mkdir $APP_HOME -p
WORKDIR $APP_HOME

WORKDIR /usr/src

ADD . $APP_HOME

RUN echo 'for f in /app/config/*-sample.yml; do mv "$f" "${f/-sample.yml/.yml}"; done' | bash -

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
	apt-get install -y nodejs && \
	cd /app && \
	RAILS_ENV=production bundle && \
	RAILS_ENV=production bundle exec rake assets:precompile

RUN if [ -f /app/tmp/pids/server.pid ]; then rm /app/tmp/pids/server.pid; fi

RUN mv /app/config/graphs-sample.json.erb /app/config/graphs.json.erb

EXPOSE 3000
CMD ["rails", "s"]