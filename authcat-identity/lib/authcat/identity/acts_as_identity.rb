# frozen_string_literal: true

module Authcat
  module Identity
    module ActsAsIdentity
      def acts_as_identity(identity = nil, **opts)
        if identity.nil?
          SelfBuilder.build(self, identity, **opts)
        else
          AttrBuilder.build(self, identity, **opts)
        end
      end

      class SelfBuilder
        def self.build(model, _identity = nil, **_opts)
          define_identify_method(model)
        end

        def self.define_identify_method(model)
          model.generated_identity_methods.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def identify(value, **opts)
              identity = self.class.identify(value, **opts)

              if identity
                @association_cache = identity.instance_variable_get(:@association_cache) if instance_variable_defined?(:@association_cache)
                @attributes = identity.instance_variable_get(:@attributes)
                @new_record = false
                @previously_new_record = false if instance_variable_defined?(:@previously_new_record)
              end

              identity
            end
          RUBY
        end
      end

      class AttrBuilder
        def self.build(model, identity, **opts)
          define_identify_method(model, identity, **opts)
        end

        def self.define_identify_method(model, identity, class_name: identity.to_s.classify)
          model.generated_identity_methods.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def identify_#{identity}(value, **opts)
              identity = #{class_name}.identify(value, **opts)

              if identity
                self.#{identity} = identity
              end

              identity
            end
          RUBY
        end
      end
    end
  end
end
