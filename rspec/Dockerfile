FROM ruby:3.0.0

WORKDIR /usr/src/
COPY ["Gemfile", "Gemfile.lock", "./"]
RUN bundle install

COPY . .
CMD ["bundle", "exec", "irb"]
