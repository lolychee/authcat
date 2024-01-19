# frozen_string_literal: true

module Authcat
  module Identifier
    module Reflections
      class Attribute < Authcat::Credential::Reflections::Attribute
        def type_class
          Identifier::Type.resolve(options[:type] || :identifier)
        end
      end
    end
  end
end
