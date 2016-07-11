module Authcat
  module Strategies
    class Cookies < Base
      option :key, require: true

      option :permanent, false
      option :signed, false
      option :encrypted, true

      option :domain, nil
      option :path, nil
      option :secure, false
      option :httponly, true

      option :expires_at, nil
      option :expires_in, nil

      def authenticate
        identity = credential.find
        yield identity if identity && block_given?
        identity
      end

      def sign_in(identity = auth.identity)
        self.credential = credential_class.create(identity)
      end

      def sign_out
        clear
      end

      def credential
        @credential ||= credential_class.new(cookies[key])
      end

      def credential=(credential)
        cookies[key] = cookies_options.merge(value: credential.to_s)
        @credential = credential
      end

      def clear
        request.cookie_jar.delete(key)
        @credential = nil
      end

      def cookies
        @cookies ||= config.slice(:permanent, :signed, :encrypted).select {|_, v| v }.keys \
          .reduce(request.cookie_jar) {|cookies, method_name| cookies.send(method_name) }
      end

      def cookies_options
        @cookies_options ||= begin
          opts = config.slice(:domain, :path, :secure, :httponly)
          if expires_at
            expires = expires_at.respond_to?(:call) ? expires_at.(auth.identity) : expires_at
            opts[:expires] = expires
          elsif expires_in
            expires = expires_in.respond_to?(:call) ? expires_in.(auth.identity) : expires_in
            expires = expires.from_now  if expires.is_a?(ActiveSupport::Duration)
            opts[:expires] = expires
          end
          opts
        end
      end

      def exists?
        request.cookie_jar.key?(key)
      end

      def readonly?
        false
      end

    end
  end
end
