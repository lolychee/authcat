class UserSession < ApplicationRecord
  include Authcat::Session::SessionRecord
  include ExtraAction

  belongs_to :user

  enum :state, %i[identified granted revoked]

  # track :ip, :country, :region, :city, :location, :user_agent

  extra_action :identify, do: -> { _identify }

  extra_action :challenge, do: -> { _challenge }

  extra_action :sign_out, do: :destroy

  extra_action :revoke, do: :destroy

end
