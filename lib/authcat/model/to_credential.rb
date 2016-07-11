module Authcat
  module Model
    module ToCredential
      extend ActiveSupport::Concern

      def to_credential(type = :globalid, **options)
        Authcat::Credentials.create(type, self, **options)
      end
    end
  end
end
