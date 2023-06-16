# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      class HasMany
        include Base
        include Relatable

        def valid_option_keys
          @valid_option_keys = ActiveRecord::Associations::Builder::HasMany.send(:valid_options, options)
        end

        def setup_relation!
          owner.has_many(name, relation_scope, **relation_options)
        end
      end
    end
  end
end
