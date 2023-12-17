# frozen_string_literal: true

module Authcat
  module Password
    module Type
      include Authcat::Utils::Registryable

      register(:digest_password) { DigestPassword }
      register(:one_time_password) { OneTimePassword }
    end
  end
end
