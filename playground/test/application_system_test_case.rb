# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |options|
    options.args << "--headless"
    options.args << "--disable-gpu"
    # Sandbox cannot be used inside unprivileged Docker container
    options.args << "--no-sandbox"
    options.args << "--disable-dev-shm-usage"
  end
end
