module Authcat
  module Model
    module Password
      extend ActiveSupport::Concern

      module ClassMethods
        def password_attributes
          @password_attributes ||= Hash.new {|_, k| raise ArgumentError, "unknown password attribute: #{k.inspect}" }
        end

        def password_attribute(attribute, algorithm = :bcrypt, **options)
          algorithm = ::Authcat::Password.const_get(algorithm) if algorithm.is_a?(Symbol) || algorithm.is_a?(String)

          password_attributes[attribute] = [algorithm, options]

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

        algorithm, options = self.class.password_attributes[attribute]
        algorithm.new(hashed_password, **options)
      end

      def write_password_attribute(attribute, hashed_password)
        if hashed_password.nil?
          write_attribute(attribute, nil)
        else
          algorithm, options = self.class.password_attributes[attribute]
          write_attribute(attribute, algorithm.new(hashed_password, **options).to_s)
        end
      end

      def verify_password(attribute, raw_password)
        return false if raw_password.nil?

        password = read_password_attribute(attribute)
        return false if password.nil?

        password.verify(raw_password)
      end

      def write_password(attribute, raw_password)
        algorithm, options = self.class.password_attributes[attribute]
        write_password_attribute(attribute, algorithm.create(raw_password, **options))
      end

    end
  end
end
