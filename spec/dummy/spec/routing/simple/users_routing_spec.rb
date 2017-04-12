require "rails_helper"

RSpec.describe Simple::UsersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/simple/users").to route_to("simple/users#index")
    end

    it "routes to #new" do
      expect(get: "/simple/users/new").to route_to("simple/users#new")
    end

    it "routes to #show" do
      expect(get: "/simple/users/1").to route_to("simple/users#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/simple/users/1/edit").to route_to("simple/users#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/simple/users").to route_to("simple/users#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/simple/users/1").to route_to("simple/users#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/simple/users/1").to route_to("simple/users#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/simple/users/1").to route_to("simple/users#destroy", id: "1")
    end

  end
end
