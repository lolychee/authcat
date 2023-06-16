# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      module Relatable
        attr_reader :relation_options

        def extract_options!(*)
          super
          extract_relation_options!(options)
        end

        def valid_option_keys
          {}
        end

        def extract_relation_options!(options)
          @relation_options = {
            inverse_of: owner.name.underscore.to_sym,
            class_name: relation_class_name
          }.merge(options.extract!(*valid_option_keys))
        end

        def relation_class_name
          @relation_class_name ||= "#{owner.name}#{name.to_s.classify}"
        end

        def relation_scope
          nil
        end

        def setup_relation!
          raise NotImplementedError
        end

        def setup!
          setup_relation!
          setup_instance_methods!
        end
      end
    end
  end
end
