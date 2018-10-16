# frozen_string_literal: true

module Authcat
  module Password
    module SecurePassword
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def has_secure_password(attribute = :password, column_name: "#{attribute}_digest", algorithm: Password.default_algorithm, accessor: true, **opts, &block)
          attribute column_name, :password, algorithm: algorithm, **opts

          if accessor
            if opts[:array]
              class_eval <<-METHOD
                attr_reader :#{attribute}

                def #{attribute}=(value)
                  self.#{column_name} = Array(value).map {|v| ::Authcat::Password.new(:plaintext, v) }
                  @#{attribute} = value
                end

                def #{attribute}_verify(password)
                  value = self.#{column_name}
                  value ? value.any? {|v| v.verify(password) } : false
                end
              METHOD
            else
              class_eval <<-METHOD
                attr_reader :#{attribute}

                def #{attribute}=(value)
                  self.#{column_name} = ::Authcat::Password.new(:plaintext, value)
                  @#{attribute} = value
                end

                def #{attribute}_verify(password)
                  value = self.#{column_name}
                  value ? value.verify(password) : false
                end
              METHOD
            end
          end
        end
      end
    end
  end
end
