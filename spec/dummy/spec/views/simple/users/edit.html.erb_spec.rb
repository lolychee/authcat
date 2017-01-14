require 'rails_helper'

RSpec.describe "simple/users/edit", type: :view do
  before(:each) do
    @simple_user = assign(:simple_user, Simple::User.create!())
  end

  it "renders the edit simple_user form" do
    render

    assert_select "form[action=?][method=?]", simple_user_path(@simple_user), "post" do
    end
  end
end
