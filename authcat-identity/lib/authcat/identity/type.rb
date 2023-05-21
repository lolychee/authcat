# frozen_string_literal: true

module Authcat
  module Identity
    module Type
      include Authcat::Credential::Registryable

      register(:identifier) { Identifier }
      register(:email) { Email }
      register(:phone_number) { PhoneNumber }
      register(:token) { Token }
      # register(:username) { Username }
    end
  end
end
