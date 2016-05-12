module Authcat
  class Digest
    class Error < StandardError
    end
    module Errors
      class InvalidHash < Digest::Error
      end
    end
  end
end
