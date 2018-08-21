module Authcat
  module Tokenizer
    extend ActiveSupport::Autoload
    extend Support::Registrable

    autoload :Abstract
    autoload :JWT, "authcat/tokenizer/jwt"
    
    register :jwt, :JWT
  end
end