module Authcat
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :HasPassword

    include HasPassword
    include Authcat::Validators
  end
end
