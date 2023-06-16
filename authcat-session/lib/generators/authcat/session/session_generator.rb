# frozen_string_literal: true

require "rails/generators/active_record"
require "active_support"

module Authcat
  class SessionGenerator < ActiveRecord::Generators::Base
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
             [model_name, "#{singular_name}:belongs_to", "name:string", "token:string", *attributes], **options
    end

    def inject_marco_content
      inject_into_file "app/models/#{model_singular_name}.rb", "  include Authcat::Session::Record \n\n",
                       after: /class #{model_name}.*\n/
      inject_into_file "app/models/#{singular_name}.rb", "  has_many_sessions\n",
                       after: /class #{name}.*\n/
    end

    def model_name
      "#{name}Session"
    end

    def model_singular_name
      @model_singular_name ||= model_name.underscore.singularize
    end

    def singular_name
      @singular_name ||= name.underscore.singularize
    end
  end
end
