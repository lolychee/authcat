begin
  require "rails/railtie"
rescue LoadError
else

  module Authcat
    class Railtie < Rails::Railtie
      module ControllerMixin
        extend ActiveSupport::Concern

        module ClassMethods
          def authcat(*args, **opts, &block)
            use ::Authcat::Middleware, *args, **opts, &block
          end
        end

        def authenticator
          request.authenticator
        end
      end

      module RequestMixin
        def authenticator
          @authenticator ||= env[::Authcat::Authenticator::ENV_KEY]
        end
      end

      initializer "authcat" do |app|
        Authcat.secret_key ||= Rails.application.secrets.secret_key_base

        ActionDispatch::Request.include RequestMixin

        ActiveSupport.on_load(:action_controller) do
          send :include, ControllerMixin
        end
      end
    end
  end

end
