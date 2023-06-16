# frozen_string_literal: true

require "authcat/identifier"
require "authcat/password"

module Authcat
  module Session
    module Record
      extend ActiveSupport::Concern

      include Authcat::Identifier::Validators
      include Authcat::Password::Validators
      include Authcat::Credential::Authenticatable

      module ClassMethods
      end
    end
  end
end
