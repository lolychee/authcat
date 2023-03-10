module Authcat
  module IdP
    module IdProviderRecord
      def self.included(base)
        base.extend ClassMethods
        base.include Authcat::IdP::Omniauth

        base.validates :provider, presence: true, uniqueness: { scope: :"#{base.identity_name}_id" }
        base.validates :token, presence: true, uniqueness: { scope: :provider }
      end

      module ClassMethods
        attr_writer :identity_name

        def identity_name
          @identity_name ||= name.delete_suffix("IdProvider").downcase
        end
      end
    end
  end
end
