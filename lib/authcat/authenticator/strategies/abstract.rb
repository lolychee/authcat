# frozen_string_literal: true

module Authcat
  class Authenticator
    module Strategies
      class Abstract
        attr_reader :tokenizer, :options
        attr_reader :name

        class << self
          def default_name
            @default_name ||= to_s.split("::").last.downcase
          end
        end

        def initialize(tokenizer, **opts, &block)
          @tokenizer = tokenizer
          @options = extract_options(opts)

          instance_eval(&block) if block_given?
        end

        def extract_options(opts)
          @name ||= opts.fetch(:as, self.class.default_name).to_sym
          opts
        end
      end
    end
  end
end
