# frozen_string_literal: true

module Authcat
  module Authenticator
    module Factors
      module Base
        attr_reader :model, :name

        def initialize(model, name, options = {})
          @model = model
          @name = name
          @options = options
        end

        def column_name
          @options.fetch(:column_name, name)
        end

        def where_chain(where_chain, value)
          where_chain.where(column_name => value)
        end

        def identify(value)
          where_chain(model, value).first
        end
      end
    end
  end
end
