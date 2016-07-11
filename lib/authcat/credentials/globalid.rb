module Authcat
  module Credentials
    class GlobalID < Base

      def self.create(identity, params: {}, **options)
        raise ArgumentError, "identity should be ActiveRecord::Base instance." unless identity.is_a?(ActiveRecord::Base)

        new(::GlobalID.create(identity, params), **options)
      end

      def self.valid?(credential)
        !::GlobalID.parse(credential).nil?
      end

      attr_reader :global_id
      delegate :app, :model_name, :model_id, :params, to: :global_id

      def replace(credential)
        @global_id = credential.is_a?(::GlobalID) ? credential : ::GlobalID.parse(credential)

        super(@global_id.to_s)
      end

      def find
        @global_id.find
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
  end
end
