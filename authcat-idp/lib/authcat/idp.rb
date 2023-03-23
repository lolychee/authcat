# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  "idp" => "IdP"
)
loader.push_dir("#{__dir__}/..")
loader.setup

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/idp/railtie"
end

module Authcat
  module IdP
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_many_idp_credentials(**opts)
        # self.identifier_attributes << :idp_credentials
        has_many :idp_credentials, class_name: "#{name}IdPCredential", extend: Extension, **opts

        define_method(:verify_idp_credential) do |idp|
          idp_credentials.verify(idp)
        end
      end
    end
  end

  module Extension
    def verify(idp)
      case idp
      when OmniAuth::AuthHash
        where(new(idp).slice(:provider, :token)).exists?
      end
    end
  end
end
