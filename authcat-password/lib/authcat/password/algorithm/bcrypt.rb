# frozen_string_literal: true

gem "bcrypt"
require "bcrypt"

module Authcat
  module Password
    module Algorithm
      class BCrypt < ::BCrypt::Password
        class << self
          alias valid? valid_hash?
        end

        alias verify ==
      end
    end
  end
end
