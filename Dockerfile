FROM ruby:3

WORKDIR /app

COPY Gemfile Gemfile.lock please.gemspec ./
COPY lib/please/version.rb ./lib/please/version.rb
RUN bundle install

COPY ./ ./
