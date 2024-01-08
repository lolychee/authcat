# frozen_string_literal: true

module Authcat
  module IdentityProvider
    module Record
      def self.included(base)
        base.extend ClassMethods
        base.include Omniauth

        base.store_full_class_name = false

        # base.validates :provider, presence: true, uniqueness: { scope: :"#{base.identity_name}_id" }
        base.validates :token, presence: true, uniqueness: { scope: :type }
      end

      module ClassMethods
        attr_writer :identity_name

        def identity_name
          @identity_name ||= name.delete_suffix("IdentityProviderCredential").downcase
        end
      end
    end
  end
end
