# frozen_string_literal: true

RSpec.describe Authcat::Credential::Reflections::Attribute do
  subject(:reflection) { described_class.new(owner, name, **options, &block) }

  let(:owner) do
    stub_const("User", Class.new(ActiveRecord::Base) { self.table_name = "users" })
  end

  let(:name) { :email }
  let(:options) { {} }
  let(:block) { nil }

  it_behaves_like "base reflection"
  it_behaves_like "identifiable reflection" do
    before do
      subject.setup_attribute!
    end

    let(:credential) { "credential" }
    let(:identify_identifier) { name }
    let(:identify_scope) { owner.where(identify_identifier => credential) }
    let(:identity) { owner.create(identify_identifier => credential) }
  end

  describe "#setup_attribute!" do
    before do
      subject.setup_attribute!
    end

    it "define attribute" do
      expect(owner.attributes_to_define_after_schema_loads).to include(name.to_s)
    end
  end
end
