# frozen_string_literal: true

RSpec.describe Authcat::MultiFactor::HasBackupCodes do
  it 'has backup codes' do
    user = User.create(email: 'test@email.com')
    codes = user.regenerate_backup_codes

    expect(user).to be_persisted
    expect(user.backup_codes).to eq codes.first
    expect(user.verify_backup_codes(codes.first)).to eq true
  end
end
