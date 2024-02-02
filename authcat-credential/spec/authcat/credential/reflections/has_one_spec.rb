# frozen_string_literal: true

RSpec.describe Authcat::Credential::Reflections::HasOne do
  subject(:reflection) { described_class.new(owner, name, **options, &block) }

  let(:owner) do
    stub_const("User", Class.new(ActiveRecord::Base) { self.table_name = "users" })
  end

  let(:name) { :session }
  let(:options) { { releation: {} } }
  let(:block) { nil }

  it_behaves_like "relation reflection"

  context "test" do
    before do
      stub_const(
        "User",
        Class.new(ActiveRecord::Base) do
          self.table_name = "users"
          has_many :sessions
        end
      )
    end

    it "equal valid_option_keys" do
      puts "haha"
      user = User.create(email: "email@example.com", password: "password")
      user.sessions.create(token: "token")

      # u = User.includes(:sessions).where.merge(Session.where({ token: "token" })).first
      binding.irb
    end
  end
end
