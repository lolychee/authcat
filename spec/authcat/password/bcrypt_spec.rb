require "spec_helper"

describe Authcat::Password::BCrypt do

  let(:password) { "password" }
  let(:hashed_password) { "$2a$10$wafe2Xu.r3jGbSuGKrxPcumjKFKrdiAYhod/XvR9UZxy9QTyhA2.W" }
  let(:new_password) { "new_password" }
  let(:new_hashed_password) { "$2a$10$wafe2Xu.r3jGbSuGKrxPcupae278dIfH.upemdE7GuTCOYiEJ2gua" }

  describe ".valid?" do
    it do
      expect(described_class.valid?(hashed_password)).to eq true
    end
  end

  describe ".extract_options" do
    it do
      options = {
        cost: 10,
        salt: "$2a$10$wafe2Xu.r3jGbSuGKrxPcu",
        version: "2a",
      }
      expect(described_class.extract_options(hashed_password)).to eq options
    end
  end

  describe ".hash" do
    it do
      hashed_password = described_class.hash(password)
      expect(described_class.valid?(hashed_password)).to eq true
    end 
  end

  describe ".rehash" do
    it do
      expect(described_class.rehash(hashed_password, new_password)).to eq new_hashed_password
    end
  end
end