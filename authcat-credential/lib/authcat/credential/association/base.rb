# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      module Base
        attr_reader :owner, :name, :options

        def initialize(owner, name, **options, &block)
          @owner = owner
          @name = name
          extract_options!(options)
          @block = block
        end

        def extract_options!(options)
          @type = options.delete(:type)
          @options = options
        end

        def setup!
          raise NotImplementedError
        end
      end
    end
  end
end
