module Authcat
  module Identity
    module SignIn
      def self.setup(base)
        base.include self

        base.define_callbacks :sign_in

        base.attribute :identifier, :string
        base.attribute :password,   :string

        base.validates :identifier, presence: true, found: true, on: :sign_in
        base.validates :password, presence: true, password_verify: { was: true }, on: :sign_in
      end

      def sign_in(attributes = {})
        self.attributes = attributes
        valid?(:sign_in) &&
        run_callbacks(:sign_in) do
          save
        end
      end
    end
  end
end
