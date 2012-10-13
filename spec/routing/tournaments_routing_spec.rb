# -*- encoding : utf-8 -*-
require "spec_helper"

describe TournamentsController do
  describe "routing" do
    it "routes to #index" do
      get("/tournaments").should route_to("tournaments#index")
    end
  end

end
