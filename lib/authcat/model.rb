module Authcat
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    eager_autoload do
      autoload :SecurePassword
      autoload :Tokenable
      autoload :Validators
    end

    eager_load!

    include SecurePassword
    include Tokenable
    include Validators
  end
end
