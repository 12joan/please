FROM ruby:3

WORKDIR /app

RUN apt-get update -y && apt-get install vim nano -y

COPY Gemfile Gemfile.lock please.gemspec ./
COPY lib/please/version.rb ./lib/please/version.rb
RUN bundle install

COPY ./ ./
