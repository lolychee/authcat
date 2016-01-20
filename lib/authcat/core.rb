module Authcat
  module Core
    extend ActiveSupport::Concern

    included do
      attr_reader :request, :options

      attr_accessor :user

      cattr_accessor :default_options, instance_writer: false

    end

    module ClassMethods

      def define_option_method(*names)
        names.each do |name|
          instance_eval <<-METHOD
            def #{name}(*args)
              args.empty? ? @#{name} : self.#{name} = args.first
            end

            def #{name}=(value)
              @#{name} = value
            end
          METHOD

          class_eval <<-METHOD
            def #{name}
              self.class.instance_variable_get(:@#{name})
            end
          METHOD
        end
      end

    end

    def initialize(request, **options)
      @request = request
      @options = options
    end

    # %w[authenticate login logout].each do |name|
    #   module_eval <<-METHOD
    #     def #{name}(*args, &block)
    #       _#{name}(*args, &block)
    #     end
    #   METHOD
    # end

    def authenticate(*args, &block)
      _authenticate(*args, &block)
    end

    def login(*args, &block)
      _login(*args, &block)
    end

    def logout(*args, &block)
      _logout(*args, &block)
    end

  end
end
