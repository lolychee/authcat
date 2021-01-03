# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, '.rb')
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.setup

require 'rack'

module Authcat
  class Passport
    def initialize(app, _opts = {})
      @app = Rack::Builder.new(app)
      @providers = []
      yield
      @providers.each { |provider| @app.use provider.to_middleware }
    end

    def call(env)
      @app.call(env)
    end
  end
end
