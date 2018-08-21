begin
  require "jwt"
rescue LoadError
  $stderr.puts "You don't have jwt installed in your application. Please add it to your Gemfile and run bundle install"
  raise
end


module Authcat
  module Tokenizer
    class JWT < Abstract
      def initialize(**opts)
        super
        @algorithm = opts.fetch(:algorithm, "HS256")
        @secret_key = opts.fetch(:secret_key) do
          @algorithm == "none" ? nil : raise(ArgumentError, "secret_key is required.")
        end
      end

      def encode(payload)
        ::JWT.encode(payload_with_claims(payload), @secret_key, @algorithm)
      end

      def decode(token, validate: true)
        ::JWT.decode(token, @secret_key, validate, validate_headers)
      end

      private

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
