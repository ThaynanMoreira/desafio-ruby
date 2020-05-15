
FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /ruby_app

WORKDIR /ruby_app

ADD Gemfile /ruby_app/Gemfile
# ADD Gemfile.lock /ruby_app/Gemfile.lock

RUN bundle install
ADD . /ruby_app