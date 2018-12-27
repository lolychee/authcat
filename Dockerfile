FROM ruby:2.5-alpine

RUN apk add --no-cache \
    build-base \
    gcc \
    git \
    ca-certificates \
    tzdata \
    sqlite-dev \
    postgresql-dev \
    nodejs \
    yarn

ENV AUTHCAT_HOME /src/authcat
RUN mkdir -p $AUTHCAT_HOME
ENV DUMMY_APP_HOME $AUTHCAT_HOME/spec/dummy

COPY . $AUTHCAT_HOME
WORKDIR $DUMMY_APP_HOME

RUN gem install bundler \
    && bundle install --jobs 10 --deployment

RUN bundle exec rails assets:precompile

EXPOSE 80

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["puma"]
