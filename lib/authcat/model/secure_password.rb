module Authcat
  module Model
    module SecurePassword
      extend ActiveSupport::Concern

      module ClassMethods
        def password_attributes
          @password_attributes ||= Hash.new { |_, k| raise ArgumentError, "unknown password attribute: #{k.inspect}" }
        end

        def password_attribute(attribute, algorithm = :bcrypt, **options, &block)
          algorithm = algorithm.is_a?(Class) ? algorithm : ::Authcat::Password.lookup(algorithm)

          password_attributes[attribute] = proc { |hashed_password| algorithm.new(hashed_password, **options, &block) }

          class_eval <<-METHOD
            def #{attribute}
              read_password_attribute(:#{attribute})
            end

            def #{attribute}=(value)
              write_password_attribute(:#{attribute}, value)
            end
          METHOD
        end
      end

      def read_password_attribute(attribute)
        hashed_password = read_attribute(attribute)

        return nil if hashed_password.nil?

        algorithm = self.class.password_attributes[attribute]
        algorithm.(hashed_password)
      end

      def write_password_attribute(attribute, hashed_password)
        value = if hashed_password.nil?
          nil
        else
          algorithm = self.class.password_attributes[attribute]
          algorithm.(hashed_password).to_s
        end

        write_attribute(attribute, value)
      end

      def verify_password(attribute, raw_password)
        return false if raw_password.nil?

        password = read_password_attribute(attribute)
        return false if password.nil?

        password.verify(raw_password)
      end

      def write_password(attribute, raw_password)
        algorithm = self.class.password_attributes[attribute]
        write_password_attribute(attribute, algorithm.().digest(raw_password))
      end
    end
  end
end
