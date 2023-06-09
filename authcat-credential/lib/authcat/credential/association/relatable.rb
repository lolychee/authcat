# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      module Relatable
        attr_reader :owner, :name, :options

        def initialize(owner, name, **options, &block)
          @owner = owner
          @name = name
          @type = options.delete(:as)
          @options = options
          @block = block
        end

        def setup!
          raise NotImplementedError
        end
      end
    end
  end
end
