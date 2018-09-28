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
          ::JWT.encode(payload_with_claims(payload, **opts), fetch_secret_key(opts[:secret_key]), @algorithm)
        end

        def untokenize(token, validate: true, **opts)
          payload, _ = ::JWT.decode(token, fetch_secret_key(opts[:secret_key]), validate, validate_headers)
          payload
        end

        private

          def extract_options(opts)
            @algorithm = opts.fetch(:algorithm, self.class.default_algorithm)
            @secret_key_base = opts.fetch(:secret_key_base) do
              @algorithm == "none" ? nil : raise(ArgumentError, "option :secret_key_base is required.")
            end
            opts
          end

          def fetch_secret_key(key)
            if key.nil?
              @secret_key_base
            else
              raise ArgumentError, "#{key.inspect} is not a String" unless key.is_a?(String)
              @secret_key_base + key
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
