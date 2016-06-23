module Authcat
  module Credentials
    class GlobalID < Base

      begin
        require 'globalid'
      rescue
        $stderr.puts "You don't have globalid installed in your application. Please add it to your Gemfile and run bundle install"
        raise
      end

      def self.valid?(credential)
        !::GlobalID.parse(credential).nil?
      end

      def self.generate_credential(user)
        raise ArgumentError, "user should be ActiveRecord::Base instance." unless user.is_a?(ActiveRecord::Base)

        ::GlobalID.create(user).to_s
      end

      def find_user
        ::GlobalID.find(self)
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
  end
end
