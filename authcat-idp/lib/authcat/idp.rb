# frozen_string_literal: true

require "active_support"
require "authcat"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.inflector.inflect(
  "idp" => "IdP"
)
loader.setup

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/idp/railtie"
end

module Authcat
  module IdP
    extend ActiveSupport::Concern

    include Marcos
  end
end
