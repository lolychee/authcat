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
      def has_many_id_providers(**opts)
        # self.identifier_attributes << :id_providers
        has_many :id_providers, class_name: "#{name}IdProvider", **opts do
          def verify(idp)
            case idp
            when OmniAuth::AuthHash
              where(new(idp).slice(:provider, :token)).exists?
            end
          end
        end
      end
    end
  end
end
