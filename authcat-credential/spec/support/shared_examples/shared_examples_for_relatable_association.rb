# frozen_string_literal: true

RSpec.shared_examples_for "relatable reflection" do
  it_behaves_like "identifiable reflection" do
    before do
      subject.setup_relation!
    end

    let(:options) { { identify: { identifier: identify_identifier } } }

    let(:credential) { "credential" }
    let(:identify_identifier) { :token }
    let(:identify_scope) { owner.includes(name).where(name => { identify_identifier => credential }) }
    let(:identity) do
      owner.create.tap do |record|
        reflection = owner.reflect_on_association(name)
        reflection.klass.create(reflection.send(:inverse_name) => record, identify_identifier => credential)
      end
    end
  end

  describe "#setup_relation!" do
    it "defines relation" do
      subject.setup_relation!
      expect(owner.reflect_on_association(name)).to be_present
    end
  end

  describe "#relation_options" do
    it "returns relation options" do
      # Add your test code here
    end
  end
end
