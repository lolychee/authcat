# frozen_string_literal: true

module Authcat
  module Credential
    module Reflections
      class Relation
        include Base

        attr_reader :relation_options

        def identify_where_clause(credential)
          reflection = relation_class.credential_reflections[:data]
          owner.includes(name).where(name => reflection.identify_where_clause(credential).where_values_hash)
        end

        def relation_class
          owner.reflect_on_association(name).klass
        end

        def relation_marco_name
          raise NotImplementedError
        end

        def relation_scope
          nil
        end

        def relation_option_keys(*)
          []
        end

        def extract_relation_options!(options)
          # @relation_options = {
          #   inverse_of: owner.name.underscore.to_sym,
          #   class_name: relation_class_name
          # }.merge(options.extract!(*valid_option_keys))
          @relation_options = options.extract!(*relation_option_keys(options))
          options
        end

        def extract_options!(*)
          extract_relation_options!(super)
        end

        def setup_relation!
          owner.public_send(relation_marco_name, name, relation_scope, **relation_options)
        end

        def setup!
          setup_relation!
          super
        end
      end
    end
  end
end
