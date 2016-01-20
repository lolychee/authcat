module Authcat
  module Callbacks
    extend ActiveSupport::Concern

    include ActiveSupport::Callbacks

    CALLBACK_NAMES_AND_TYPES = {
      initialize:   %i[after],
      validate:     %i[before after around],
      authenticate: %i[before after around],
      login:        %i[before after around],
      logout:       %i[after]
    }
    CALLBACK_NAMES = CALLBACK_NAMES_AND_TYPES.keys

    included do |base|
      define_callbacks *CALLBACK_NAMES
    end

    module ClassMethods
      CALLBACK_NAMES_AND_TYPES.each do |name, types|
        types.each do |type|
          define_method("#{type}_#{name}") do |*args, &block|
            set_callback(name, type, *args, &block)
          end
        end
      end
    end

    CALLBACK_NAMES.each do |name|
      module_eval <<-METHOD
        def #{name}(*)
          run_callbacks(:#{name}) { super }
        end
      METHOD
    end

  end
end
