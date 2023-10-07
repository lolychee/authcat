# frozen_string_literal: true

require "active_support"
require "authcat"
require "zeitwerk"

Zeitwerk::Loader.for_gem_extension(Authcat).tap do |loader|
  loader.inflector.inflect(
    "idp" => "IdP"
  )
  loader.setup
end

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/idp/railtie"
end

module Authcat
  module IdP
    def self.included(base)
      base.include Marcos
    end
  end
end
