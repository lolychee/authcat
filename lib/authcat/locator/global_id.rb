module Authcat
  module Locator
    class GlobalID < Abstract
      def key
        options.fetch(:key, "gid")
      end

      def find(location)
        ::GlobalID.find(location[key])
      end

      def to_location(identity)
        {
          key => ::GlobalID.create(identity)
        }
      end
    end
  end
end
