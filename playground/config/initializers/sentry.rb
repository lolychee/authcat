# frozen_string_literal: true

return unless ENV.key?("SENTRY_DSN")

Sentry.init do |config|
  config.dsn = ENV.fetch("SENTRY_DSN", nil)
  config.breadcrumbs_logger = %i[sentry_logger http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 0.5
end
