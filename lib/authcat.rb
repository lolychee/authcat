# frozen_string_literal: true

require "zeitwerk"

module Authcat
  def self.loader
    @loader ||= Zeitwerk::Loader.for_gem
  end

  loader.setup
end
