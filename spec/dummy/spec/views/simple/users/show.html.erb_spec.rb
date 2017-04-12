require "rails_helper"

RSpec.describe "simple/users/show", type: :view do
  before(:each) do
    @simple_user = assign(:simple_user, Simple::User.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
