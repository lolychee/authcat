require 'rails_helper'

RSpec.describe "simple/users/index", type: :view do
  before(:each) do
    assign(:simple_users, [
      Simple::User.create!(),
      Simple::User.create!()
    ])
  end

  it "renders a list of simple/users" do
    render
  end
end
