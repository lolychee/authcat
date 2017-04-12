begin
  require "rails/railtie"
rescue LoadError
else

  module Authcat
    class Railtie < Rails::Railtie
      module ControllerMixin
        extend ActiveSupport::Concern

        module ClassMethods
          def authenticator(name, klass = nil, **options)
            klass ||= "#{name.to_s.capitalize}Authenticator".constantize

            iv_name = "@authenticator"
            define_method(:authenticator) do
              instance_variable_get(iv_name) || instance_variable_set(iv_name, klass.new(request, **options))
            end

            class_eval <<-RUBY
              def current_user
                authenticator.identity || authenticator.authenticate
              end

              def authenticate_user!
                authenticator.identity || authenticator.authenticate!
              end

              delegate :signed_in?, to: :authenticator

              helper_method :current_user, :signed_in?
            RUBY
          end
        end
      end

      initializer "authcat" do |app|
        ActiveSupport.on_load(:action_controller) do
          send :include, Authcat::Railtie::ControllerMixin
        end
      end
    end
  end

end
