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
        if user = credential.find
          throw :success, user
        end
      end

      def sign_in(user, params = {})
        if expires_at
          cookies_options[:expires] = expires_at.respond_to?(:call) ? expires_at.(user) : expires_at
        else
          if expires_in
            expires_in = expires_in.(user) if expires_in.respond_to?(:call)
            cookies_options[:expires] = expires_in.is_a?(Integer) ? expires_in.from_now : expires_in
          end
        end

        self.credential = credential_class.create(user, params)
      end

      def sign_out
        clear_credential!
      end

      def credential
        credential_class.new(cookies[key])
      end

      def credential=(credential)
        cookies[key] = cookies_options.merge(value: credential.to_s)
      end

      def clear_credential!
        request.cookie_jar.delete(key)
      end

      def cookies
        @cookies ||= config.slice(:permanent, :signed, :encrypted).select {|_, v| v }.keys \
          .reduce(request.cookie_jar) {|cookies, method_name| cookies.send(method_name) }
      end

      def cookies_options
        @cookies_options ||= config.slice(:domain, :path, :secure, :httponly)
      end

      def present?
        request.cookie_jar.key?(key)
      end

      def readonly?
        false
      end

    end
  end
end
