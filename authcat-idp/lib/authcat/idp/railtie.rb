# frozen_string_literal: true

require "active_support"

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "IdP"
end

module Authcat
  module IdP
    # Railtie to hook into Rails.
    class Railtie < ::Rails::Railtie
      initializer "add inflections" do
      end

      generators do
      end
    end
  end
end
