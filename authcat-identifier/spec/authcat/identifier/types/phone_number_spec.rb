# frozen_string_literal: true

RSpec.describe Authcat::Identifier::Types::PhoneNumber do

  before do
    Phonelib.default_country = "CN"
  end

  let(:phone_number) { '13012341234' }
  let(:phone_number_masked) { '130****1234' }

  it 'does something useful' do
    user = User.new(phone_number: phone_number)
    user.save

    expect(User.where(phone_number: phone_number)).to be_exists
    expect(user.phone_number_masked).to eq phone_number_masked
  end

  it 'sign in' do
    User.new(phone_number: phone_number)
    user = User.new(phone_number: phone_number)

    expect(user.valid?(:phone_number_sign_in)).to eq true
    expect(user.id).to be_present
    expect(user.new_record?).to eq false
  end
end
