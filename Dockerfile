FROM ruby:2.3

# for a JS runtime
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV AUTHCAT_HOME /src/authcat
ENV DUMMY_APP_HOME /src/authcat/spec/dummy

RUN mkdir -p $AUTHCAT_HOME

COPY . $AUTHCAT_HOME
WORKDIR $DUMMY_APP_HOME

ENV RAILS_ENV production
ENV RACK_ENV production

RUN gem install bundler
RUN bundle install --deployment
RUN bundle exec rails assets:precompile

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "$PORT"]
