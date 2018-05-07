FROM ruby:2.2.10-slim AS build
MAINTAINER Bruno Marques <brunoppl@gmail.com>

#Install development libs and nodejs for javascript engine
RUN apt update && apt install -y  nodejs gcc make libsqlite3-dev && apt-get clean

#Creating Working Directory
RUN mkdir /app 
WORKDIR /app
#Adding Gemfile and installing gems
ADD Gemfile  /app/ 

RUN bundle install --without test development \
&& rm -rf /usr/local/bundle/cache/*.gem \
&& find /usr/local/bundle/gems/ -name "*.c" -delete \
&& find /usr/local/bundle/gems/ -name "*.o" -delete
#Adding application files to container
ADD . /app
#Running database migrations
RUN rake db:migrate 

#Exposing Rails port and starting the server
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


