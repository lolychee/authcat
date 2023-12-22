# frozen_string_literal: true

require "active_support"
require "zeitwerk"

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/idp/railtie"
end

module Authcat
  module IdP
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.inflector.inflect(
      "idp" => "IdP"
    )
    loader.setup

    def self.included(base)
      base.include Marcos
    end
  end
end
