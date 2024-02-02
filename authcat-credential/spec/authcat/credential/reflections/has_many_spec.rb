# frozen_string_literal: true

RSpec.describe Authcat::Credential::Reflections::HasMany do
  subject(:reflection) { described_class.new(owner, name, **options, &block) }

  let(:owner) do
    stub_const("User", Class.new(ActiveRecord::Base) { self.table_name = "users" })
  end

  let(:name) { :sessions }
  let(:options) { { releation: {} } }
  let(:block) { nil }

  it_behaves_like "relation reflection"
end
