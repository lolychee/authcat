module Authcat
  module Support
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Configurable
      autoload :Registrable
    end

    eager_load!
  end
end
