require 'active_support/hash_with_indifferent_access'

module Authcat
  class AuthHash < ActiveSupport::HashWithIndifferentAccess

    class << self
      def from_json(data)
        new(JSON.parse(data))
      end
    end
  end
end
