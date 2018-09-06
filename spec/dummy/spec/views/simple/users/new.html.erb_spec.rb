# frozen_string_literal: true

require "rails_helper"

RSpec.describe "simple/users/new", type: :view do
  before(:each) do
    assign(:simple_user, Simple::User.new)
  end

  it "renders new simple_user form" do
    render

    assert_select "form[action=?][method=?]", simple_users_path, "post" do
    end
  end
end
