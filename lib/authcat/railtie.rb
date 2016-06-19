begin
  require 'rails/railtie'
  rescue LoadError
else

  module Authcat
    class Railtie < Rails::Railtie

      initializer 'authcat' do |app|
        ActiveSupport.on_load(:action_controller) do
          send :include, Authcat::Authentication
        end
      end

    end
  end

end
