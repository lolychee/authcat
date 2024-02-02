# frozen_string_literal: true

module Authcat
  module Password
    module Type
      class Password < Authcat::Credential::Type::Credential
        self.default_options = { algorithm: :bcrypt }

        def build_coder(options)
          Coder.new(**options)
        end

        class Coder
          def initialize(algorithm:, **options)
            @klass = Algorithm.resolve(algorithm)
            @options = options
          end

          def parse(value, **options)
            return value if value.is_a?(@klass)

            if value.is_a?(Algorithm::Plaintext)
              @klass.create(value.to_s, **@options.merge(options))
            # elsif @value_klass.valid?(value)
            else
              @klass.new(value.to_s, **@options.merge(options))
            end
          end

          def load(value)
            return nil if value.nil?

            parse(value)
          end

          def dump(value)
            return if value.nil?

            load(value).to_s
          end
        end
      end
    end
  end
end
