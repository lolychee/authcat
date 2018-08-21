module Authcat
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    eager_autoload do
      autoload :SecurePassword
      autoload :Locatable
      autoload :Tokenable
      autoload :Validators
    end

    include SecurePassword
    include Locatable
    include Tokenable
    include Validators
  end
end
