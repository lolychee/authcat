module Authcat
  class Provider
    include Authcat::Options::Optionable

    def initialize(**options)
      apply_options(options)
    end
  end
end
