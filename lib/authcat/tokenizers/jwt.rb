# frozen_string_literal: true

begin
  require "jwt"
rescue LoadError
  $stderr.puts "You don't have jwt installed in your application. Please add it to your Gemfile and run bundle install"
  raise
end

module Authcat
  module Tokenizers
    class JWT < Abstract
      class << self
        attr_accessor :algorithm
        self.algorithm = "HS256"
      end

      def tokenize(payload, signature_key: @signature_key, algorithm: @algorithm)
        ::JWT.encode(payload_with_claims(payload), signature_key, algorithm)
      end

      def untokenize(token, signature_key: @signature_key, validate: true)
        payload, _ = ::JWT.decode(token, signature_key, validate, validate_headers)
        payload
      end

      private

        def extract_options(opts)
          @algorithm = opts.fetch(:algorithm, self.class.algorithm)
          @signature_key = opts.fetch(:signature_key) do
            @algorithm == "none" ? nil : raise(ArgumentError, "option :signature_key is required.")
          end
          super
        end

        def payload_with_claims(payload)
          payload[:exp] ||= (Time.now + expires_in).to_i if expires_in = @options[:expires_in]
          payload[:exp] ||= expires_at.to_i if expires_at = @options[:expires_at]
          payload[:iat] ||= Time.now.to_i
          payload
        end

        def validate_headers
          {
            algorithm: @algorithm
          }
        end
    end
  end
end
