# frozen_string_literal: true

module Authcat
  class Password
    class Coder
      def initialize(crypto:, array: false, **opts)
        @crypto = crypto
        @array = array
        @opts = opts
      end

      def load(data)
        return if data.nil?

        if @array
          JSON.parse(data).each do |str|
            Password.new(str, crypto: @crypto, **@opts)
          end
        else
          Password.new(data, crypto: @crypto, **@opts)
        end
      end

      def dump(password)
        return if password.nil?

        if @array
          password.map { |pwd| Password.create(pwd, crypto: @crypto, **@opts).to_s }.to_json
        else
          Password.create(password, crypto: @crypto, **@opts).to_s
        end
      end
    end
  end
end
