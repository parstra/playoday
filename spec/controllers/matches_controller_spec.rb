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
    context "invalid data for comment" do
      let(:tournament) { FactoryGirl.create(:tournament) }
      let(:round) { FactoryGirl.create(:round, tournament: tournament, active: true) }
      let(:match) { FactoryGirl.create(:match, round: round) }
      let(:played_match) { FactoryGirl.create(:match, round: round, played: true) }


      let(:inactive_round) { FactoryGirl.create(:round, tournament: tournament, active: false) }
      let(:inactive_match) { FactoryGirl.create(:match, round: inactive_round) }

      before do
        tournament.users << user
        match.home_player = user
      end

    end
    context "unauthorized user" do
      it "should redirect to /"
    end

    context "valid data" do
      let(:tournament) { FactoryGirl.create(:tournament) }
      let(:round) { FactoryGirl.create(:round, tournament: tournament, active: true) }
      let(:match)  { FactoryGirl.create(:match, round: round, home_player: user) }
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

