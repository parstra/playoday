require 'spec_helper'

describe MatchesController do
  # TODO: change to factory girl
  let(:user){User.create({:email => 'someone@someone.com',
                          :password => 'foobar'})}
  let(:another_user){User.create({:email => 'someoneelse@someone.com',
                                  :password => 'foobar'})}
  before do
    login_user(user)
  end

  describe "POST trashtalk" do
    context "invalid data (tournament, match or comment)" do
      let(:tournament) { FactoryGirl.create(:tournament) }
      let(:round) { FactoryGirl.create(:round, tournament: tournament, active: true) }
      let(:match) { FactoryGirl.create(:match, round: round) }

      let(:inactive_round) { FactoryGirl.create(:round, tournament: tournament, active: false) }
      let(:inactive_match) { FactoryGirl.create(:match, round: inactive_round) }

      it "should redirect to /" do
        post :trashtalk, { :tournament_id => '-1', :id => match.id}
        response.should redirect_to( root_path )

        post :trashtalk, { :tournament_id => tournament.id, :id => '-1'}
        response.should redirect_to( root_path )
      end
      it "should redirect to tournament page" do
        post :trashtalk, { :tournament_id => tournament.id, :id => match.id}
        response.should redirect_to tournament_path tournament

        post :trashtalk, { :tournament_id => tournament.id, :id => inactive_match.id }
        response.should redirect_to tournament_path tournament
      end
    end
    context "unauthorized user" do
      it "should redirect to /"
    end

    context "valid data" do
      let(:tournament) { FactoryGirl.create(:tournament) }
      let(:round) { FactoryGirl.create(:round, tournament: tournament, active: true) }
      let(:match) { FactoryGirl.create(:match, round: round, home_player: user) }
      let(:match2) { FactoryGirl.create(:match, round: round, away_player: user) }

      it "should create a comment for home_player and match" do
        match.home_comment.should be_nil
        post :trashtalk, { :tournament_id => tournament.id,
                                    :id => match.id,
                                    :comment => 'I will crush you' }
        match.reload
        match.home_comment.should == 'I will crush you'
      end

      it "should create a comment for away_player and match" do
        match2.away_comment.should be_nil
        post :trashtalk, { :tournament_id => tournament.id,
                                    :id => match2.id,
                                    :comment => 'I will crush you' }
        match2.reload
        match2.away_comment.should == 'I will crush you'
      end

      it "should redirect to tournament's active round" do
        post :trashtalk, { :tournament_id => tournament.id,
                           :id => match.id,
                           :comment => 'I will crush you' }

        response.should redirect_to tournament_path tournament

      end
    end
  end
end

