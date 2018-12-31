# frozen_string_literal: true

module Authcat
  module Password
    module SecurePassword
      def self.included(base)
        base.extend ClassMethods
        class << base
          attr_accessor :password_suffix
        end
        base.password_suffix ||= "_digest"
      end

      module ClassMethods
        def has_secure_password(attribute = :password, column_name: "#{attribute}#{self.password_suffix}", algorithm: Password.default_algorithm, accessor: true, helper: true, validation: true, **opts, &block)
          attribute column_name, :password, algorithm: algorithm, **opts

          self.validates column_name, presence: true, on: :save if validation

          mod = Module.new

          mod.attr_reader attribute if accessor
          if opts[:array]
            mod.class_eval <<-RUBY if accessor
              def #{attribute}=(value)
                self.#{column_name} = value.respond_to?(:map) ? value.map {|v| ::Authcat::Password.new(:plaintext, v) } : nil
                @#{attribute} = value
              end
            RUBY

            mod.class_eval <<-RUBY if helper
              def #{attribute}_verify(password, **opts)
                column_name = #{column_name.to_s.inspect}
                column_name += "_was" if opts[:was]
                (send(column_name) || []).any? {|pwd| pwd == password }
              end
            RUBY

          else

            mod.class_eval <<-RUBY if accessor
              def #{attribute}=(value)
                self.#{column_name} = ::Authcat::Password.new(:plaintext, value)
                @#{attribute} = value
              end
            RUBY

            mod.class_eval <<-RUBY if helper
              def #{attribute}_verify(password, **opts)
                column_name = #{column_name.to_s.inspect}
                column_name += "_was" if opts[:was]

                send(column_name) == password
              end
            RUBY

          end

          self.include mod if mod.instance_methods(false).any?
        end
      end
    end
  end
end
