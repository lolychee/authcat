# frozen_string_literal: true

module Authcat
  module Password
    module Reflections
      class HasMany < Authcat::Credential::Reflections::HasMany
        def type
          Type.resolve(options.fetch(:type, :password)).new(**type_options)
        end

        def type_options
          options
        end

        def identifiable?
          false
        end

        def relation_options
          type = type_class.new(ActiveRecord::Type::String.new, **type_options)
          @relation_options.merge(extend: Extension.new(type))
        end

        def setup_instance_methods!
          inverse_of_name = owner.reflect_on_association(name).send(:inverse_name)

          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{inverse_of_name}: self, password: value)
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
