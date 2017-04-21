require "spec_helper"

describe Authcat::Validators::RecordFoundValidator do

  let!(:user_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = User.table_name

      include Authcat::Model

      password_attribute :password_digest
      attr_accessor :password

      validates :email, record_found: true, on: :sign_in

      before_save { |user| user.write_password(:password_digest, user.password) }
    end
  end

  context "record exists" do
    # 时间存入SQLite数据库会丢失精度，reload来同步
    let(:someone) { user_class.create(email: "someone@example.com", password: "password").reload }

    it "replace @attributes" do
      user = user_class.new(email: someone.email)

      expect(user.valid?(:sign_in))
      expect(user.instance_variable_get("@attributes")).to eq someone.instance_variable_get("@attributes")
    end
  end

  context "record not exists" do
    it "add a email error" do
      user = user_class.new(email: "someone@example.com")

      expect(user.invalid?(:sign_in))
      expect(user.errors).to include(:email)
      expect(user.errors[:email]).to include("not found")
    end
  end

end
