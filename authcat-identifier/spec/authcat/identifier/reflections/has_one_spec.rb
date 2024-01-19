RSpec.describe Authcat::Identifier::Reflections::HasOne do
  let(:public_email) { "public_email@example.com" }

  before do
    stub_const("User", Class.new(ActiveRecord::Base) do
      include Authcat::Identifier

      has_many_identifiers :emails, identify: { identifier: :identifier }
      has_one_identifier :public_email, class_name: "Email", identify: { identifier: :identifier }
    end)
  end

  it "identify by emails" do
    User.create(public_email:)

    user = User.new

    expect(user.identify({ public_email: })).to be_persisted
  end
end
