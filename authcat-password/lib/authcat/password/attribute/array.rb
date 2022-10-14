# frozen_string_literal: true

module Authcat
  module Password
    class Attribute
      module Array
        def array?
          true
        end

        def create(passwords = [], *args)
          Array(passwords).map { |pwd| super(pwd, *args) }
        end

        def verify(plaintext, ciphertext)
          !ciphertext.nil? && Array(ciphertext).any? { |pwd| super(plaintext, pwd) }
        end

        def load(value)
          if value.is_a?(String) && value.start_with?("[") && value.end_with?("]")
            JSON.parse(value).map { |pwd| super(pwd) }
          elsif value.respond_to?(:to_a)
            value.to_a.map { |pwd| super(pwd) }
          else
            super(value)
          end
        end

        def dump(value)
          return if value.nil?

          value.map { |pwd| super(pwd) }.to_json
        end
      end
    end
  end
end
