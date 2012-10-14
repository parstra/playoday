# -*- encoding : utf-8 -*-
require "spec_helper"

describe MatchesController do
  describe "routing" do
    it "routes to #edit" do
      get("/tournaments/1/matches/11/edit").should route_to(controller: 'matches',
                                                           action: 'edit',
                                                           tournament_id: '1',
                                                           id: '11')
    end
    it "routes to #update" do
      put("/tournaments/1/matches/11").should route_to(controller: 'matches',
                                                              action: 'update',
                                                              tournament_id: '1',
                                                              id: '11')
    end
    it "routes to #edit" do
      get("/tournaments/1/matches/11").should route_to(controller: 'matches',
                                                       action: 'show',
                                                       tournament_id: '1',
                                                       id: '11')
    end
    it "routes to #trash_talk" do
      post("/tournaments/1/matches/11/trashtalk").should route_to(controller: 'matches',
                                                                  action: 'trashtalk',
                                                                  tournament_id: '1',
                                                                  id: '11')
    end
  end

end
