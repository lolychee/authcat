require "rails/generators/active_record"
require "active_support"

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "IdP"
end

class Authcat::IdpGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

  class_option :migration, type: :boolean, default: true
  class_option :timestamps, type: :boolean, default: true
  class_option :parent, type: :string, default: "ApplicationRecord", desc: "The parent class for the generated model"
  class_option :indexes, type: :boolean, default: true, desc: "Add indexes for references and belongs_to columns"
  class_option :primary_key_type, type: :string, desc: "The type for primary key"
  class_option :database, type: :string, aliases: %i[--db],
                          desc: "The database for your model's migration. By default, the current environment's primary database is used."

  def create_migration_file
    # return if skip_migration_creation?
    # attributes.each { |a| a.attr_options.delete(:index) if a.reference? && !a.has_index? } if options[:indexes] == false
    migration_template "create_table_migration.rb", File.join(db_migrate_path, "create_#{table_name}.rb")
  end

  def create_model_file
    generate_abstract_class if database && !custom_parent?

    # generate "migration AddWebAuthnColumnsTo#{identity_name} webauthn_user_id:string webauthn_challenge:string"
    inject_into_file "app/models/#{identity_singular_name}.rb", "  has_many_id_providers\n",
                     after: /class #{identity_name}.*\n/

    template "model.rb", File.join("app/models", class_path, "#{file_name}.rb")
  end

  private

  alias identity_name name

  def identity_singular_name
    @identity_singular_name ||= identity_name.underscore.singularize
  end

  def name
    "#{identity_name}IdProvider"
  end

  def parse_attributes!
    self.attributes = [
      Rails::Generators::GeneratedAttribute.parse("#{identity_singular_name}:belongs_to"),
      Rails::Generators::GeneratedAttribute.new("provider", "string", false, { null: false }),
      Rails::Generators::GeneratedAttribute.new("token", "string", false, { null: false }),
      Rails::Generators::GeneratedAttribute.new("metadata", "string", false, { null: false })
    ] + super
  end

  def attributes_with_index
    attributes.select { |a| !a.reference? && a.has_index? }
  end

  # Used by the migration template to determine the parent name of the model
  def parent_class_name
    if custom_parent?
      parent
    elsif database
      abstract_class_name
    else
      parent
    end
  end

  def generate_abstract_class
    path = File.join("app/models", "#{database.underscore}_record.rb")
    return if File.exist?(path)

    template "abstract_base_class.rb", path
  end

  def abstract_class_name
    "#{database.camelize}Record"
  end

  def database
    options[:database]
  end

  def parent
    options[:parent]
  end

  def custom_parent?
    parent != self.class.class_options[:parent].default
  end

  def migration
    options[:migration]
  end
end
