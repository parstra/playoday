# -*- encoding : utf-8 -*-
require "spec_helper"

describe TournamentsController do
  describe "routing" do
    it "routes to #index" do
      get("/tournaments").should route_to("tournaments#index")
    end

    it "routes to #start" do
      post("/tournaments/12/start").should route_to({controller: 'tournaments',
                                                     action: 'start',
                                                     id: '12'})
    end
    it "routes to #next_round" do
      post("/tournaments/12/next_round").should route_to({controller: 'tournaments',
                                                     action: 'next_round',
                                                     id: '12'})
    end

    it "routes to #close" do
      post("/tournaments/12/close").should route_to({controller: 'tournaments',
                                                          action: 'close',
                                                          id: '12'})
    end


  end

end
