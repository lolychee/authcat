# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      class HasOne
        include Relatable
        attr_reader :relation_options

        def extract_options!(*)
          super
          extract_relation_options!(options)
        end

        def extract_relation_options!(options)
          valid_option_keys = ActiveRecord::Associations::Builder::HasOne.send(:valid_options, options)
          @relation_options = {
            inverse_of: owner.name.underscore.to_sym,
            class_name: relation_class_name
          }.merge(options.extract!(*valid_option_keys))
        end

        def relation_class_name
          raise NotImplementedError
        end

        def setup_relation!
          name = self.name
          owner.has_one(name, -> { where(name: name) }, **relation_options)
        end

        def setup!
          setup_relation!
          setup_instance_methods!
        end
      end
    end
  end
end
