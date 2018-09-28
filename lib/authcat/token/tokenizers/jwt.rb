# frozen_string_literal: true

begin
  require "jwt"
rescue LoadError
  $stderr.puts "You don't have jwt installed in your application. Please add it to your Gemfile and run bundle install"
  raise
end

module Authcat
  module Token
    module Tokenizers
      class JWT < Abstract
        class << self
          attr_accessor :default_algorithm
        end
        self.default_algorithm = "HS256"

        def tokenize(payload, **opts)
          ::JWT.encode(payload_with_claims(payload, **opts), get_signature_key(opts[:signature_key]), @algorithm)
        end

        def untokenize(token, validate: true, **opts)
          payload, _ = ::JWT.decode(token, get_signature_key(opts[:signature_key]), validate, validate_headers)
          payload
        end

        private

          def extract_options(opts)
            @algorithm = opts.fetch(:algorithm, self.class.default_algorithm)
            @signature_key_base = opts.fetch(:signature_key_base) do
              @algorithm == "none" ? nil : raise(ArgumentError, "option :signature_key_base is required.")
            end
            opts
          end

          def get_signature_key(key)
            if key.nil?
              @signature_key_base
            else
              raise ArgumentError, "#{key.inspect} is not a String" unless key.is_a?(String)
              @signature_key_base + key
            end
          end

          def payload_with_claims(payload, **opts)
            options = @options.merge(opts)
            payload[:exp] ||= (Time.now + expires_in).to_i if expires_in = options[:expires_in]
            payload[:exp] ||= expires_at.to_i if expires_at = options[:expires_at]
            payload[:iat] ||= Time.now.to_i
            payload
          end

          def validate_headers
            { algorithm: @algorithm }
          end
      end
    end
  end
end
