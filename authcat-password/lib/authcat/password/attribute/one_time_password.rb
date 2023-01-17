module Authcat
  module Password
    class Attribute
      class OneTimePassword < Digest
        self.default_algorithm = :totp

        def define_instance_methods!
          super
          define_regenerator_method!
          setup_callback!
        end

        def define_regenerator_method!
          model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def regenerate_#{attribute_name}(*args)
              update!(#{attribute_name}: self.class.#{attribute_name}.create(*args))
            end

            def clear_#{attribute_name}()
              update!(#{attribute_name}: nil)
            end
          RUBY
        end

        def setup_callback!
          if options[:burn_after_verify]
            model.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
              set_callback :verify_#{attribute_name}, :after, -> { update_column(#{attribute_name.inspect}, #{attribute_name}.select {|code| !code.last_verified? }) }
            RUBY
          end
        end
      end
    end
  end
end
