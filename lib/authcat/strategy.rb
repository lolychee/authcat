module Authcat
  module Strategy
    extend ActiveSupport::Autoload
    extend Support::Registrable

    autoload :Abstract
    autoload :Session
    autoload :Cookies

    register :session,  :Session
    register :cookies,  :Cookies
  end
end
