# frozen_string_literal: true

module Authcat
  module Authenticator
    module Marcos
      # def auth_methods
      #   @auth_methods ||= []
      # end

      # authenticate :user do
      #   method :password, provider: :http_authentication, type: :basic do
      #     identify :username
      #     verify :password
      #   end
      #   method :password, provider: :model do
      #     identify :login
      #     verify :password
      #     verify :captcha_response
      #   end
      # end

      # def auth_method(*, **, &)
      #   auth_methods << Method.new(*, **, &)
      # end

      def authenticate; end
    end
  end
end
