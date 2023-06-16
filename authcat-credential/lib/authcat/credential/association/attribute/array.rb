# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      class Attribute
        module Array
          def array?
            options[:array]
          end
        end
      end
    end
  end
end
