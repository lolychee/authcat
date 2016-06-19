module Authcat
  module Credentials
    class Base
      include Support::Configurable

      module ClassMethods
        def create(user, **options)
          credential = new(nil, **options)
          credential.user = user
          credential
        end
      end

      def self.inherited(subclass)
        subclass.extend ClassMethods
      end

      def initialize(credential = nil, **options)
        config.merge!(options)
      end

      attr_reader :user

      def user=(user)
        @user = user
      end

      def to_user
        user
      end

      def to_s
        nil
      end

    end
  end
end
