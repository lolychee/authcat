#!/usr/bin/env sh

# gem sources --remove https://gems.ruby-china.com/ --add https://rubygems.org/
# gem install bundler # solargraph steep
# solargraph download-core $RUBY_VERSION

# bundle config set mirror.https://rubygems.org/ https://gems.ruby-china.com/

# sudo chown vscode:vscode -R .
bin/setup
cd playground
bin/setup
