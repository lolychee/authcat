# frozen_string_literal: true

module Authcat
  module Password
    module SecurePassword
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def has_secure_password(attribute = :password, column_name: "#{attribute}_digest", algorithm: Password.default_algorithm, accessor: true, helper: true, **opts, &block)
          attribute column_name, :password, algorithm: algorithm, **opts

          if accessor
            mod = Module.new

            mod.attr_reader attribute
            if opts[:array]
              mod.class_eval <<-RUBY
                def #{attribute}=(value)
                  self.#{column_name} = value.respond_to?(:map) ? value.map {|v| ::Authcat::Password.new(:plaintext, v) } : nil
                  @#{attribute} = value
                end
              RUBY

              mod.class_eval <<-RUBY if helper
                def #{attribute}_verify(password)
                  (self.#{column_name} || []).any? {|pwd| pwd == password }
                end
              RUBY
            else
              mod.class_eval <<-RUBY
                def #{attribute}=(value)
                  self.#{column_name} = ::Authcat::Password.new(:plaintext, value)
                  @#{attribute} = value
                end
              RUBY

              mod.class_eval <<-RUBY if helper
                def #{attribute}_verify(password)
                  self.#{column_name} == password
                end
              RUBY
            end

            self.include mod
          end
        end
      end
    end
  end
end
