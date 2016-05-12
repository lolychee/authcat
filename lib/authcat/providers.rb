require 'authcat/providers/session_provider'

module Authcat
  module Providers

    def self.lookup(name)
      const_get("#{name}_provider".camelize, false)
    end

  end
end
