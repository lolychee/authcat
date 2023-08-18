# frozen_string_literal: true

module Authcat
  module Password
    module Record
      def self.included(base)
        base.include Password
      end
    end
  end
end
