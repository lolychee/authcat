module Authcat
  module IdP
    module IdProviderRecord
      def self.included(base)
        base.included Authcat::IdP::Omniauth

        base.validates :provider, presence: true, uniqueness: { scope: :user_id }
        base.validates :token, presence: true, uniqueness: { scope: :provider }
      end
    end
  end
end
