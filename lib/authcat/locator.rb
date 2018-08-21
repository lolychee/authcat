module Authcat
  module Locator
    extend ActiveSupport::Autoload
    extend Support::Registrable

    autoload :Abstract
    autoload :GlobalID, "authcat/locator/global_id"
    
    register :global_id, :GlobalID
  end
end