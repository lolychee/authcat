# frozen_string_literal: true

module Authcat
  module Credential
    module Reflections
      module Base
        attr_reader :owner, :name, :options

        def initialize(owner, name, **options, &block)
          @owner = owner
          @name = name
          extract_options!(options)
          @block = block
        end

        def extract_options!(options)
          @options = options
        end

        def setup_class_methods!; end
        def setup_instance_methods!; end

        def setup!
          setup_class_methods!
          setup_instance_methods!
        end
      end
    end
  end
end
