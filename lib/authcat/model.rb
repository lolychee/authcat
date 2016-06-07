module Authcat
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :Extensions
    autoload :Validators

    include Extensions::Password
    include Validators
  end
end
