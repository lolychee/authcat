module Authcat
  module Session
    module SessionRecord
      def self.included(base)
        base.extend ClassMethods

        base.attribute :request, default: -> { Current.request }
      end

      module ClassMethods

      end
    end
  end
end
