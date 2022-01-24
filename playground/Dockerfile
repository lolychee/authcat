# syntax=docker/dockerfile:1
FROM ruby:2.7-slim

RUN apt-get update -qq \
    && apt-get install -y -qq \
    build-essential \
    curl \
    git \
    libcurl4-openssl-dev \
    libffi-dev \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    zlib1g-dev \
    && (curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -) \
    && apt-get install --no-install-recommends -y -qq nodejs libpq-dev libsqlite3-dev \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
ENV PORT 80
EXPOSE $PORT

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV APP_HOME /app
ENV PATH ${APP_HOME}/bin:$PATH

WORKDIR $APP_HOME

COPY Gemfile* ./
RUN BUNDLE_JOBS=$(nproc) gem install bundler \
    && bundle config set deployment 'true' \
    && bundle config set without 'development test' \
    && bundle install

COPY . ./
RUN bootsnap precompile --gemfile app/ lib/
RUN SECRET_KEY_BASE=true rake assets:precompile

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
