# frozen_string_literal: true

module Authcat
  module MFA
    module RecoveryCodes
      # @return [void]
      def self.included(base)
        base.include OneTimePassword
        base.extend ClassMethods
      end

      module ClassMethods
        # @return [Symbol]
        def has_recovery_codes(attribute = :recovery_codes, **opts)
          has_one_time_password attribute, array: true, engine: :bcrypt, after_verify: lambda {
                                                                                         update_column(attribute, send(attribute).select do |code|
                                                                                                                    !code.last_verified?
                                                                                                                  end)
                                                                                       }, **opts
        end
      end
    end
  end
end
