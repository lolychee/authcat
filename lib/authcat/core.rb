module Authcat
  module Core
    extend ActiveSupport::Concern

    include Support::Configurable

    def initialize(request, **options)
      # raise ArgumentError unless request.is_a?(Rack::Request)
      @request = request

      config.merge!(options)
    end

    def user_or_authenticate
       authenticate unless authenticated?
       user
    end

    def authenticate
      @authenticated = true
      user
    end

    def authenticate!
      authenticate || raise(Unauthenticated)
    end

    def authenticated?
      @authenticated
    end

    def sign_in(user)
      self.user = user
    end

    def signed_in?
      !user_or_authenticate.nil?
    end

    def sign_out
      @authenticated = false
      self.user = nil
    end

    private

      attr_reader :request, :user

      def user=(user)
        unless user.nil?
          raise ArgumentError, "user should be ActiveRecord::Base instance and presisted." unless user.is_a?(ActiveRecord::Base) && user.persisted?
        end

        @user = user
      end

  end
end
