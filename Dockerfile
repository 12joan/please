FROM ruby:3

WORKDIR /app

RUN apt-get update -y && apt-get install vim nano -y

COPY Gemfile Gemfile.lock please.gemspec ./
COPY lib/please/version.rb ./lib/please/version.rb
RUN bundle install

COPY ./ ./
RUN ln -s /app/exe/please /usr/local/bin/please

ENTRYPOINT ["bundle", "exec"]
CMD ["echo", "Try running 'please say hello'"]
