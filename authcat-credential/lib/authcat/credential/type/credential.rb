# frozen_string_literal: true

require "active_record/type"

module Authcat
  module Credential
    module Type
      class Credential < ActiveRecord::Type::String
      end
    end
  end
end
