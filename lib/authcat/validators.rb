module Authcat
  module Validators
    extend ActiveSupport::Autoload

    autoload :VerifyPasswordValidator
    autoload :RecordFoundValidator
  end
end
