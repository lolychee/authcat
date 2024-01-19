# frozen_string_literal: true

module Authcat
  module Credential
    module Reflections
      class HasOne
        include Base
        include Relatable

        def relation_option_keys(options)
          ActiveRecord::Associations::Builder::HasOne.send(:valid_options, options)
        end

        def relation_marco_name
          :has_one
        end
      end
    end
  end
end
