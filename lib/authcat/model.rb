module Authcat
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :SecurePassword

    include SecurePassword
    include Authcat::Validators
  end
end
