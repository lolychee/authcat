# frozen_string_literal: true

module Authcat
  module Password
    module Type
      class OneTimePassword < Password
        include Authcat::Support::ActsAsRegistry

        register(:totp) { ROTP::TOTP }
        register(:hotp) { ROTP::HOTP }

        self.default_options = { otp_type: :totp }

        def build_coder(options)
          Coder.new(**options)
        end

        class Coder
          def initialize(otp_type:, **options)
            @klass = OneTimePassword.resolve(otp_type)
            @options = options
          end

          def dump(value)
            return if value.nil?

            value.to_s
          end

          def load(value)
            return nil if value.nil?

            @klass.new(value.to_s, **@options)
          end
        end
      end
    end
  end
end
