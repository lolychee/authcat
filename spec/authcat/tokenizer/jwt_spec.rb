require "spec_helper"

describe Authcat::Tokenizer::JWT do

  let(:user) { User.new(id: 1) }

  subject { described_class.new(global_id) }

  describe "#encode" do
    
  end
end
