# frozen_string_literal: true

module Authcat
  module Identity
    class Verification < Module
      def initialize(attribute, **_opts)
        define_method("#{attribute}_verified") do
        end
      end
    end
  end
end
