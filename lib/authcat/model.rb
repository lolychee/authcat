module Authcat
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :SecurePassword
    autoload :ToCredential
    autoload :Validators

    include SecurePassword
    include ToCredential
    include Validators
  end
end
