# frozen_string_literal: true

module Authcat
  module Credential
    module Reflections
      class HasMany
        include Base
        include Relatable

        def valid_option_keys(options)
          ActiveRecord::Associations::Builder::HasMany.send(:valid_options, options)
        end

        def relation_marco_name
          :has_many
        end
      end
    end
  end
end
