# frozen_string_literal: true

require "rails"

module Authcat
  module WebAuthn
    class Engine < Rails::Engine # :nodoc:
      isolate_namespace Authcat::WebAuthn

      config.eager_load_namespaces << Authcat::WebAuthn

      initializer "inflector" do
        Rails.autoloaders.each do |autoloader|
          autoloader.inflector.inflect(
            "webauthn" => "WebAuthn"
          )
        end
      end
    end
  end
end
