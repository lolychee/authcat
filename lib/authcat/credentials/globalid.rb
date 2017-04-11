module Authcat
  module Credentials
    class GlobalID < Abstract

      def self.valid?(credential)
        !::GlobalID.parse(credential).nil?
      end

      attr_reader :global_id
      delegate :app, :model_name, :model_id, :params, to: :global_id

      def _update(identity)
        @global_id = ::GlobalID.create(identity)
        @raw_data = global_id.to_s
      end

      def _find
        global_id.find
      rescue ActiveRecord::RecordNotFound
        nil
      end

      private

        def global_id
          @global_id ||= ::GlobalID.parse(raw_data)
        end

        def valid_identity?(identity)
          identity.class < ActiveRecord::Base
        end
    end
  end
end
