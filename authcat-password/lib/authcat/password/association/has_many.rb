# frozen_string_literal: true

module Authcat
  module Password
    module Association
      class HasMany < Authcat::Credential::Association::HasMany
        def type_class
          Password::Type.resolve(@type || :digest_password)
        end

        def type_options
          options
        end

        def relation_options
          type = type_class.new(ActiveRecord::Type::String.new, **type_options)
          @relation_options.merge(extend: Extension.new(type))
        end

        def setup_instance_methods!
          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{relation_options[:inverse_of]}: self, password: value)
              end
            end
          RUBY
        end

        class Extension < Module
          def initialize(type)
            super()
            define_method(:verify) do |pwd|
              load_target.each do |record|
                return true if type.deserialize(record.password) == pwd
              end
              false
            end
          end
        end
      end
    end
  end
end
