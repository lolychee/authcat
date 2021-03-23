# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, '.rb')
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  'has_webauthn' => 'HasWebAuthn'
)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module MultiFactor
    # @return [void]
    def self.included(base)
      gem 'authcat-password'
      require 'authcat/password'

      base.extend ClassMethods
      base.include \
        Authcat::Password::HasPassword,
        Authcat::Password::Validators,
        HasOneTimePassword,
        HasBackupCodes,
        HasWebAuthn
    end

    class AuthenticationBuilder
      def initialize(base, attribute = nil, default: %w[], &block)
        @base = base
        @attribute = attribute
        @default_id_type, @default_auth_type = *default
        @name = [attribute, "authenticate"].compact.join("_").to_sym
        @mapping = Hash.new { |hash, key| hash[key] = [] }

        instance_eval(&block) if block_given?
      end

      def factor(name, identifier:)
        @mapping[name.to_s] += Array(identifier).map(&:to_s)
      end

      def build
        @base.define_model_callbacks @name
        @base.attribute :id_type, default: @default_id_type
        @base.attribute :auth_type, default: @default_auth_type
        @base.delegate *@mapping.keys, to: @attribute, prefix: true, allow_nil: true

        @base.validates :auth_type, inclusion: { in: @mapping.keys }, on: @name
        @mapping.values.reduce(&:|).each do |id|
          @base.validates id, identify: @attribute.nil? ? true : @attribute, if: -> { self.id_type == id }, on: @name
        end

        @mapping.each do |factor, ids|
          @base.validates :id_type, inclusion: { in: ids }, if: -> { self.auth_type == factor }, on: @name
          @base.attribute :"#{factor}_attempt", :string
          @base.validates :"#{factor}_attempt", authenticate: [@attribute, factor].compact.join("_").to_sym, if: -> { self.auth_type == factor }, on: @name
        end

        @base.class_eval "def #{@name}; valid?(:#{@name}) && run_callbacks(:#{@name}) end"
      end
    end

    module ClassMethods
      def multi_factor_authentication(attribute = nil, **opts, &block)
        AuthenticationBuilder.new(self, attribute, **opts, &block).build
      end
    end
  end
end
