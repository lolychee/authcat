# frozen_string_literal: true

require "authcat/support"

module Authcat
  module Identifier
    module Type
      include Authcat::Support::ActsAsRegistry

      register(:identifier) { Identifier }
      register(:email) { Email }
      register(:phone_number) { PhoneNumber }
      register(:token) { Token }
      # register(:username) { Username }
    end
  end
end
