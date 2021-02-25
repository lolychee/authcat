#!/usr/bin/env sh

gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem install bundler solargraph steep
solargraph download-core $RUBY_VERSION

bundle config set mirror.https://rubygems.org/ https://gems.ruby-china.com/

sudo chown vscode:vscode playground/tmp/cache playground/node_modules

bin/setup
