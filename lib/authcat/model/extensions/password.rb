module Authcat
  module Model
    module Extensions
      module Password
        extend ActiveSupport::Concern

        module ClassMethods
          def password_attributes
            @password_attributes ||= Authcat::Registry.new
          end

          def password_attribute(attribute, algorithm = :bcrypt, **options)
            algorithm =  Authcat::Password.lookup(algorithm) unless algorithm.is_a?(Class)

            # raise ArgumentError, "Unknown digest provider: %s" % digest.inspect unless digest.is_a?(Authcat::Digest)

            password_attributes[attribute] = [algorithm, options]

            # define_attribute_methods attribute

            class_eval <<-METHOD
              def #{attribute}
                #{}
                read_password_attribute(:#{attribute})
              end

              def #{attribute}=(value)
                write_password_attribute(:#{attribute}, value)
              end
            METHOD
          end

        end

        def read_password_attribute(attribute)
          algorithm, options = self.class.password_attributes[attribute]
          hashed_password = read_attribute(attribute)
          hashed_password.nil? ? nil : algorithm.new(hashed_password, **options)
        end

        def write_password_attribute(attribute, password)
          unless password.nil?
            algorithm, _ = self.class.password_attributes[attribute]
            raise ArgumentError unless password.is_a?(algorithm)
          end
          write_attribute(attribute, password)
        end

        def verify_password(attribute, raw_password)
          return false if raw_password.nil?

          password = read_password_attribute(attribute)
          password.nil? ? false : password.verify(raw_password)
        end

        def create_password(attribute, raw_password)
          algorithm, options = self.class.password_attributes[attribute]
          write_attribute(attribute, algorithm.create(raw_password, **options))
        end

      end
    end
  end
end
