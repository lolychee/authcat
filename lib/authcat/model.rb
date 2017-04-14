module Authcat
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :SecurePassword
    autoload :Validators

    include SecurePassword
    include Validators
  end
end
