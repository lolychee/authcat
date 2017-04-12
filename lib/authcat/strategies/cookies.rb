module Authcat
  module Strategies
    class Cookies < Abstract
      option :key, required: true

      option :permanent, false
      option :signed, false
      option :encrypted, true

      option :domain, nil
      option :path, nil
      option :secure, false
      option :httponly, true

      option :expires_at, nil
      option :expires_in, nil

      def _read
        credential_class.parse(cookies[key])
      end

      def _write(credential)
        cookies[key] = build_cookies_options(credential)
      end

      def _clear
        request.cookie_jar.delete(key)
      end

      def cookies
        config.slice(:permanent, :signed, :encrypted).select { |_, v| v }.keys \
          .reduce(request.cookie_jar) { |cookies, method_name| cookies.send(method_name) }
      end

      def build_cookies_options(credential)
        opts = config.slice(:domain, :path, :secure, :httponly)
        if expires_at
          expires = expires_at.respond_to?(:call) ? expires_at.(credential.identity) : expires_at
          opts[:expires] = expires
        elsif expires_in
          expires = expires_in.respond_to?(:call) ? expires_in.(credential.identity) : expires_in
          expires = expires.from_now  if expires.is_a?(ActiveSupport::Duration)
          opts[:expires] = expires
        end
        opts[:value] = credential.to_s
        opts
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
