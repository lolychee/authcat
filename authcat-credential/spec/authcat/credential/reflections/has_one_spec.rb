# frozen_string_literal: true

RSpec.describe Authcat::Credential::Reflections::HasOne do
  subject(:reflection) { described_class.new(owner, name, **options, &block) }

  let(:owner) do
    stub_const("User", Class.new(ActiveRecord::Base) { self.table_name = "users" })
  end

  let(:name) { :session }
  let(:options) { { releation: {} } }
  let(:block) { nil }

  it_behaves_like "base reflection"
  it_behaves_like "relatable reflection"

  it "equal valid_option_keys" do
    puts "haha"
  end
end
