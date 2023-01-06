module ExtraAction
  extend ActiveSupport::Concern

  class_methods do
    def extra_action(action_name, **opts, &block)
      define_extra_action(action_name, **opts, &block)
    end

    def define_extra_action(action_name, **opts, &block)
      case opts[:do] ||= :save
      when Symbol
        block = opts[:do].to_proc
      when Proc, Lambda
        block = opts[:do]
      end

      concerning action_name.to_s.camelize do
        included do
          define_model_callbacks action_name
        end

        define_method(action_name) do |attributes = {}|
          with_transaction_returning_status do
            assign_attributes(attributes)
            valid?(action_name) && run_callbacks(action_name) { instance_exec(self, &block) }
          end
        end

      end
    end

    def define_multistep_extra_action(action_name, **opts, &block)
    end
  end
end
