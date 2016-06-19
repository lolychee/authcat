module Authcat
  module Credentials
    class GlobalID < Base

      def self.name
        :global_id
      end

      attr_reader :global_id

      def initialize(credential = nil, **options)
        super

        unless credential.nil?
          if @global_id = ::GlobalID.parse(credential)
            @user = ::GlobalID::Locator.locate(global_id)
          else
            raise InvalidCredential, "invalid credential: #{credential.inspect}"
          end
        end

      end

      def user=(user)
        super

        @global_id = ::GlobalID.create(user) unless user.nil?
      end

      def to_s
        global_id.to_s
      end

      Credentials.register(self.name, self)
    end
  end
end
