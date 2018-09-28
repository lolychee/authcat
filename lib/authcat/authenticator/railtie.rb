# frozen_string_literal: true

begin
  require "rails/railtie"
rescue LoadError
else

  module Authcat
    class Authenticator
      class Railtie < Rails::Railtie
        module ControllerMixin
          extend ActiveSupport::Concern

          module ClassMethods
            def authcat(&block)
              klass = Class.new(::Authcat::Authenticator, &block)
              define_method(:authenticator) do
                @authenticator ||= klass.new(request.env)
              end
            end
          end
        end

        initializer "authcat.authenticator" do |app|
          ActiveSupport.on_load(:action_controller) do
            send :include, ControllerMixin
          end
        end
      end
    end
  end

end
