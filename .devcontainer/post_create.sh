#!/usr/bin/env sh

gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem install bundler solargraph
solargraph download-core $RUBY_VERSION

bundle config mirror.https://rubygems.org/ https://gems.ruby-china.com/
bundle install
