module Authcat
  module Credentials
    class GlobalID < Base

      begin
        require 'globalid'
      rescue
        $stderr.puts "You don't have globalid installed in your application. Please add it to your Gemfile and run bundle install"
        raise
      end

      def self.create(user, params = {}, **options)
        raise ArgumentError, "user should be ActiveRecord::Base instance." unless user.is_a?(ActiveRecord::Base)

        new(::GlobalID.create(user, params), **options)
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
