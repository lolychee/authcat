# frozen_string_literal: true

require "rails/generators/active_record"
require "active_support"

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "WebAuthn"
end

module Authcat
  class WebauthnGenerator < ActiveRecord::Generators::Base
    source_root File.expand_path("templates", __dir__)

    argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

    class_option :migration, type: :boolean, default: true
    class_option :timestamps, type: :boolean, default: true
    class_option :parent, type: :string, default: "ApplicationRecord", desc: "The parent class for the generated model"
    class_option :indexes, type: :boolean, default: true, desc: "Add indexes for references and belongs_to columns"
    class_option :primary_key_type, type: :string, desc: "The type for primary key"
    class_option :database, type: :string, aliases: %i[--db],
                            desc: "The database for your model's migration. By default, the current environment's primary database is used."

    def generate_model
      invoke "active_record:model",
             [model_name, "#{singular_name}:belongs_to", "webauthn_id:string", "name:string", "title:string", "public_key:string", "sign_count:integer", *attributes], **options
    end

    def inject_marco_content
      inject_into_file "app/models/#{model_singular_name}.rb", "  include Authcat::WebAuthn::Record \n  self.primary_key = :webauthn_id\m\n",
                       after: /class #{model_name}.*\n/
      inject_into_file "app/models/#{singular_name}.rb", "  has_many_webauthn_credentials\n",
                       after: /class #{name}.*\n/
    end

    def model_name
      "#{name}WebAuthnCredential"
    end

    def model_singular_name
      @model_singular_name ||= model_name.underscore.singularize
    end

    def singular_name
      @singular_name ||= name.underscore.singularize
    end
  end
end
