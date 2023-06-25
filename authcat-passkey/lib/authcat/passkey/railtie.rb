# frozen_string_literal: true

module Authcat
  module Passkey
    # Railtie to hook into Rails.
    class Railtie < ::Rails::Railtie
      initializer "add inflections" do
      end

      generators do
      end
    end
  end
end
