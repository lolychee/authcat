module Authcat
  module Credential
    module Marcos
      extend ActiveSupport::Concern

      MACRO_MAPPING = {
        has_credential: Association::Attribute,
        has_one_credential: Association::HasOne,
        has_many_credentials: Association::HasMany
      }.freeze

      included do
        class_attribute :credentials

        self.credentials = {}
      end

      module ClassMethods
        def has_credential(name, **options, &block)
          define_credential!(__method__, name, **options, &block)
        end

        def has_one_credential(name, **options, &block)
          define_credential!(__method__, name, **options, &block)
        end

        def has_many_credentials(name, **options, &block)
          define_credential!(__method__, name, **options, &block)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING[macro_name]
        end

        def define_credential!(macro_name, name, **options, &block)
          lookup_credential_klass(macro_name).new(self, name, options, &block).tap do |assoc|
            assoc.setup!
            self.credentials = credentials.merge(name => assoc)
          end
        end
      end
    end
  end
end
