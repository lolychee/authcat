# frozen_string_literal: true

module Authcat
  module Session
    module Association
      class HasOne < Authcat::Credential::Association::HasOne
        def initialize(owner, name, options)
          options[:inverse_of] = owner.name.underscore.to_sym
          options[:class_name] ||= "#{owner.name}Session"

          super(owner, name, options)
        end

        def identify(value)
          owner.includes(name).find_by(name => { token: value })
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
                build_#{name}(#{options[:inverse_of]}: self, token: value)
              end
            end
          CODE
        end
      end
    end
  end
end
