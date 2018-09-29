# frozen_string_literal: true

module Authcat
  module Password
    module SecurePassword
      module ClassMethods
        def has_secure_password(attribute = :password, column_name: "#{attribute}_digest", algorithm: Password.default_algorithm, accessor: true, **opts, &block)
          attribute column_name, :password, algorithm: algorithm, **opts

          if accessor
            class_eval <<-METHOD
              attr_reader :#{attribute}

              def #{attribute}=(value)
                self.#{column_name} = ::Authcat::Password::Algorithms::Plaintext.new(value)
                @#{attribute} = value
              end
            METHOD
          end
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end
    end
  end
end
