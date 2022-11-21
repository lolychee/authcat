require "rails/railtie"

module Authcat
  module WebAuthn
    # Railtie to hook into Rails.
    class Railtie < ::Rails::Railtie
      initializer "add inflections" do
        ActiveSupport::Inflector.inflections(:en) do |inflect|
          inflect.acronym "WebAuthn"
        end
      end

      generators do
      end
    end
  end
end
