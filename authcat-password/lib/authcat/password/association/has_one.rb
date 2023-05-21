# frozen_string_literal: true

module Authcat
  module Password
    module Association
      class HasOne < Authcat::Credential::Association::HasOne
        def initialize(owner, name, options)
          @type = options.delete(:as)
          options[:inverse_of] = owner.name.underscore.to_sym
          options[:class_name] ||= "#{owner.name}Password"

          super(owner, name, options)
        end

        def create(value)
          owner.type_for_attribute(name).encoder.parse(Algorithm::Plaintext.new(value.to_s))
        end

        def setup!
          setup_relation!
          # setup_instance_methods!
        end

        def setup_relation!
          name = self.name
          owner.has_one(name, -> { where(name: name) }, **options)
        end

        def setup_instance_methods!
          owner.class_eval <<-CODE, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{owner.name.underscore}_id: id, identifier: value, identifier_type: "#{@type}")
              end
            end
          CODE
        end
      end
    end
  end
end
