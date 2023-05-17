# frozen_string_literal: true

WebAuthn.configure do |config|
  config.origin = "http://localhost:3000"
  config.rp_name = "Playground"
end
