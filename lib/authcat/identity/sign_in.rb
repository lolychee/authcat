module Authcat
  module Identity
    module SignIn
      def self.setup(base)
        base.include self
      end

      def self.included(base)
        base.define_callbacks :sign_in
        base.attribute :identifier, :string
        base.attribute :remember_me, :boolean

        base.validates :identifier, presence: true, found: true, on: :sign_in
        base.validates :password, presence: true, password_verify: { was: true }, on: :sign_in
      end

      def sign_in(attributes = {})
        self.attributes = attributes.slice(:identifier, :password, :remember_me)
        valid?(:sign_in) &&
        run_callbacks(:sign_in) do
          save
        end
      end
    end
  end
end
