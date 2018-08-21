begin
  require "rails/railtie"
rescue LoadError
else

  module Authcat
    class Railtie < Rails::Railtie
      module ControllerMixin
        extend ActiveSupport::Concern

        module ClassMethods
          def authenticator(*args, **opts, &block)
            use ::Authcat::Authenticator, *args, **opts, &block
          end
        end

        def authenticator
          request.authenticator
        end
      end

      module RequestMixin
        def authenticator
          env[::Authcat::Authenticator::ENV_KEY]
        end
      end

      initializer "authcat" do |app|
        ActionDispatch::Request.include RequestMixin

        ActiveSupport.on_load(:action_controller) do
          send :include, ControllerMixin
        end
      end
    end
  end

end
