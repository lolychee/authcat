# frozen_string_literal: true

module Authcat
  module Authenticator
    module Validators
      class AuthenticateValidator < ActiveModel::EachValidator
        def initialize(name, **)
          @name = name
          yield(self) if block_given?
        end
      end
    end
  end
end
