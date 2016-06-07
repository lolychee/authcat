require 'active_model/validator'

module Authcat
  module Model
    module Validators
      extend ActiveSupport::Autoload

      autoload :VerifyPasswordValidator
      autoload :RecordFoundValidator

    end
  end
end
