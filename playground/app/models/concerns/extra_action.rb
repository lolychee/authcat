# frozen_string_literal: true

module ExtraAction
  extend ActiveSupport::Concern

  class_methods do
    def extra_action(action_name, builder: Builder, **opts, &block)
      builder.new(self, action_name, **opts, &block).setup!
    end
  end

  class Builder
    attr_reader :model, :action_name, :options

    def initialize(model, action_name, **options, &block)
      @model = model
      @action_name = action_name
      extract_options(options)
      instance_exec(self, &block) if block
    end

    def default_options
      { do: :save }.freeze
    end

    def extract_options(options)
      @options = options.reverse_merge(default_options)
    end

    def concern
      @concern ||= model.const_set(action_name.to_s.camelize, Module.new { extend ::ActiveSupport::Concern })
    end

    def define_model_callbacks!
      action_name = self.action_name

      concern.included do
        define_model_callbacks action_name
      end
    end

    def define_action_method!
      action_name = self.action_name
      do_block = options[:do].to_proc

      concern.define_method(action_name) do |attributes = {}|
        with_transaction_returning_status do
          assign_attributes(attributes)
          valid?(action_name) && run_callbacks(action_name) { instance_exec(self, &do_block) }
        end
      end
    end

    def build_concern!
      define_model_callbacks!
      define_action_method!
    end

    def setup!
      build_concern!
      model.include(concern)
    end
  end
end
