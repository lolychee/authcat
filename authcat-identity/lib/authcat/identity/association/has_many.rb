module Authcat
  module Identity
    module Association
      class HasMany < Authcat::Credential::Association::HasMany
        def initialize(owner, name, options)
          @as = options.delete(:as)
          options[:inverse_of] = owner.name.underscore.to_sym
          options[:class_name] ||= "#{owner.name}Identifier"

          super(owner, name, options)
        end

        def identify(value)
          owner.joins(name).find_by(name => { identifier: value })
        end

        def setup!
          setup_relation!
          # setup_instance_methods!
        end

        def setup_relation!
          name = self.name
          owner.has_many(name, -> { where(name: name) }, **options)
        end

        def setup_instance_methods!
          owner.class_eval <<-CODE, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{owner.name.underscore}_id: id, identifier: value, identifier_type: "#{@as}")
              end
            end
          CODE
        end
      end
    end
  end
end
