module Authcat
  module Model
    module Extensions
      module Password
        extend ActiveSupport::Concern

        module ClassMethods
          def password_attribute_options
            @password_attribute_options ||= {}
          end

          def define_password_attribute(name, digest = :BCrypt, **options)
            digest =  Authcat::Digest.lookup(digest) unless digest.is_a?(Class)

            # raise ArgumentError, "Unknown digest provider: %s" % digest.inspect unless digest.is_a?(Authcat::Digest)

            options = {
              suffix: 'digest'
            }.merge(options)

            password_attribute_options[name] = [digest, options]

            class_eval <<-METHOD
              def #{name}
                @#{name}
              end

              def #{name}=(password)
                @#{name} = password
                digest, options = self.class.password_attribute_options[:#{name}]
                send("#{name}_\#{options[:suffix]}=", digest.digest(password))
              end
            METHOD

          end

        end

        def authenticate(**attributes)
          attributes.all? do |name, value|
            digest, options = self.class.password_attribute_options.fetch(name) { raise ArgumentError, "Unknown password attribute: #{name}" }
            digest.compare(send("#{name}_#{options[:suffix]}"), value)
          end
        end

      end
    end
  end
end
