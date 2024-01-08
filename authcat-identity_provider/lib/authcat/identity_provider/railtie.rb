# frozen_string_literal: true

require "active_support"

module Authcat
  module IdentityProvider
    # Railtie to hook into Rails.
    class Railtie < ::Rails::Railtie
      initializer "add inflections" do
      end

      generators do
      end
    end
  end
end
