require 'authcat/model/extensions/password'

module Authcat
  module Model
    module Extensions
      extend ActiveSupport::Autoload

      autoload :Login
      autoload :Password

    end
  end
end
