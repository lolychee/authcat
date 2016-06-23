module Authcat
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :Password
    autoload :SignIn
    autoload :Validators

    include Password
    include Validators
  end
end
