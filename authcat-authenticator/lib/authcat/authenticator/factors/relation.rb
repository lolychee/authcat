# frozen_string_literal: true

module Authcat
  module Authenticator
    module Factors
      class Relation
        include Base

        def where_chain(where_chain, value)
          where_chain.includes(name).where(name: { column_name => value })
        end
      end
    end
  end
end
