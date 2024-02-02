# frozen_string_literal: true

module Authcat
  module Authenticator
    module Mechanisms
      module Base
        attr_reader :owner, :name

        def initialize(owner, name, **options, &)
          @owner = owner
          @name = name
          @options = options
        end

        def setup!; end
      end
    end
  end
end
