module Authcat
  module Callbacks
    extend ActiveSupport::Concern

    include ActiveSupport::Callbacks

    CALLBACK_TYPES_AND_ACTIONS = {
      initialize:   %i[after],
      validation:   %i[before after around],
      authenticate: %i[before after around],
      login:        %i[before after around],
      logout:       %i[before after around]
    }
    CALLBACK_TYPES = CALLBACK_TYPES_AND_ACTIONS.keys

    included do |base|
      define_callbacks *CALLBACK_TYPES
    end

    module ClassMethods

      # 批量定义类方法，添加 callback 的快捷方法，完整代码如下：
      #
      #   def before_authenticate(*args, &block)
      #     set_callback(:authenticate, :before, *args, &block)
      #   end
      #
      CALLBACK_TYPES_AND_ACTIONS.each do |type, actions|
        actions.each do |action|
          module_eval <<-METHOD
            def #{action}_#{type}(*args, &block)
              set_callback(:#{type}, :#{action}, *args, &block)
            end
          METHOD
        end
      end

    end

    # 批量增加 callback 调用，完整代码如下：
    #
    #   def authenticate(*)
    #     run_callbacks(:authenticate) { super }
    #   end
    #
    CALLBACK_TYPES.each do |type|
      module_eval <<-METHOD
        def #{type}(*)
          run_callbacks(:#{type}) { super }
        end
      METHOD
    end

  end
end
