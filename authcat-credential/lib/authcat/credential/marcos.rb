# frozen_string_literal: true

module Authcat
  module Credential
    module Marcos
      MACRO_MAPPING = {
        has_credential: Association::Attribute,
        has_one_credential: Association::HasOne,
        has_many_credentials: Association::HasMany
      }.freeze

      def self.included(base)
        base.extend ClassMethods

        base.class_attribute :credentials
        base.credentials = {}
      end

      module ClassMethods
        def has_credential(name, **options, &)
          define_credential!(__method__, name, **options, &)
        end

        def has_one_credential(name, **options, &)
          define_credential!(__method__, name, **options, &)
        end

        def has_many_credentials(name, **options, &)
          define_credential!(__method__, name, **options, &)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING[macro_name]
        end

        def define_credential!(macro_name, name, **options, &)
          lookup_credential_klass(macro_name).new(self, name, **options, &).tap do |assoc|
            assoc.setup!
            self.credentials = credentials.merge(name => assoc)
          end
        end
      end
    end
  end
end
