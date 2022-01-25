# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user
  attribute :request_id, :user_agent, :ip_address

  # resets { Time.zone = nil }

  # def user=(user)
  #   super
  #   Time.zone = user.time_zone
  # end
end
