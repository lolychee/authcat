require 'authcat/model/extensions/password'

module Authcat
  module Model
    module Extensions
      extend ActiveSupport::Autoload

      autoload :SignIn
      autoload :Password

    end
  end
end
