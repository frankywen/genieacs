FROM starefossen/ruby-node:2-8

LABEL author="qm-wen<qm-wen@mygzb.com>"

RUN apt-get update && apt-get upgrade -y

RUN apt-get install mongodb -y

RUN service mongodb start

ENV APP_HOME /app/genieacs

RUN mkdir $APP_HOME -p

WORKDIR $APP_HOME

RUN npm install genieacs

EXPOSE 7557

CMD ["./start.sh"]