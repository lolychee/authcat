#!/usr/bin/env bash

gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem install bundler
bundle config mirror.https://rubygems.org/ https://gems.ruby-china.com/
bundle install
