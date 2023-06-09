# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      class HasOne
        include Relatable
        attr_reader :relation_options

        def initialize(owner, name, **, &block)
          super
          @relation_options = options.extract!(*ActiveRecord::Associations::Builder::HasOne.send(:valid_options,
                                                                                                 options))
          @relation_options[:inverse_of] = owner.name.underscore.to_sym
          @relation_options[:class_name] ||= relation_class_name
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
