# frozen_string_literal: true

require "authcat/support"

module Authcat
  module Password
    module Type
      include Authcat::Support::ActsAsRegistry

      register(:password) { Password }
      register(:one_time_password) { OneTimePassword }
    end
  end
end
