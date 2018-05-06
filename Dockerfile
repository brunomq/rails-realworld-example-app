FROM ruby:2.2.10-slim AS build
MAINTAINER Bruno Marques <brunoppl@gmail.com>

#Update and install base packages
#RUN apk update && apk upgrade && apk add curl wget bash build-base sqlite-dev ruby-json ruby-dev nodejs
RUN apt update && apt install -y  nodejs gcc make libsqlite3-dev && apt-get clean



# Clean APK cache
#RUN rm -rf /var/cache/apk/*


RUN mkdir /app 
WORKDIR /app

ADD Gemfile  /app/ 

RUN bundle install --without test development \
&& rm -rf /usr/local/bundle/cache/*.gem \
&& find /usr/local/bundle/gems/ -name "*.c" -delete \
&& find /usr/local/bundle/gems/ -name "*.o" -delete
ADD . /app
RUN rake db:migrate 
#RUN apk del build-base

#FROM ruby:2.2.10-slim
#RUN mkdir -p /app
#COPY --from=build /app /app
EXPOSE 3000
#RUN bundle install --local
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


#FROM ruby:alpine
#RUN mkdir -p /app
#COPY --from=build /usr/local/bundle/ /usr/local/bundle/
#COPY --from=build /app /app
#WORKDIR /app

#EXPOSE 3000
#CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

