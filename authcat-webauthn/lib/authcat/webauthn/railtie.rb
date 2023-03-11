# frozen_string_literal: true

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "WebAuthn"
end

module Authcat
  module WebAuthn
    # Railtie to hook into Rails.
    class Railtie < ::Rails::Railtie
      initializer "add inflections" do
      end

      generators do
      end
    end
  end
end
