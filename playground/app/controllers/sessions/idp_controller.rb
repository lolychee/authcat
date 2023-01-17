module Sessions
  class IdPController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :callback

    use OmniAuth::Builder do
      configure do |config|
        config.path_prefix = "/sign_in/idp"
      end

      provider :developer if Rails.env.development?

      if true # ENV.key?("OMNIAUTH_TWITTER_KEY")
        provider :twitter, ENV["OMNIAUTH_TWITTER_KEY"],
                 ENV.fetch("OMNIAUTH_TWITTER_SECRET", nil)
      end

      if true # ENV.key?("OMNIAUTH_GITHUB_KEY")
        provider :github, ENV["OMNIAUTH_GITHUB_KEY"],
                 ENV.fetch("OMNIAUTH_GITHUB_SECRET", nil)
      end

      if true # ENV.key?("OMNIAUTH_GOOGLE_KEY")
        provider :google_oauth2, ENV["OMNIAUTH_GOOGLE_KEY"],
                 ENV.fetch("OMNIAUTH_GOOGLE_SECRET", nil)
      end
    end

    def new
      raise ActionController::RoutingError, ""
    end

    def callback
      @session = Session.new

      respond_to do |format|
        if @session.sign_in({ sign_in_step: :omniauth_hash, omniauth_hash: request.env["omniauth.auth"],
                              remember_me: true })
          if @session.sign_in_completed?

            format.html { redirect_to root_url }
          else
            format.html { redirect_to sign_in_url }
          end
        else
          format.html { redirect_to sign_in_url }
        end
      end
    end
  end
end
