require 'spec_helper'

describe CupTournament do
  let(:user){FactoryGirl.create(:user)}

  subject {
    tournament = FactoryGirl.create(:tournament, :open, :cup, {owner: user})
    tournament.extend CupTournament
  }

  context "moving to the next round" do

    let(:players){FactoryGirl.create_list(:user, 4)}

    before do
      subject.users << players
    end

    context "first round" do
      it "creates a new round" do
        expect {subject.move_to_next_round}.to change(Round, :count).by(1)
      end

      it "assigns round to tournament" do
        subject.move_to_next_round
        subject.rounds.should_not be_empty
      end

      it "creates matches" do
        expect {subject.move_to_next_round}.to change(Match, :count).by(2)
      end

      it "assigns matches to current round" do
        subject.move_to_next_round
        round = subject.rounds.last

        round.matches.length.should == 2
      end

      it "assigns players to matches" do
        subject.move_to_next_round
        round = subject.rounds.last

        round.matches.
          collect{|m| [m.home_player_id, m.away_player_id]}.should ==
          [[players.first.id, players.second.id], [players.third.id, players.fourth.id]]
      end
    end

    context "subsequent round" do
      before do 
        # create the first round
        round = Round.new
        round.active = false
        round.tournament = subject
        round.save

        # now create the matches for the first round
        # match1  player 2 won
        match1 = Match.new
        match1.home_player_id = players.first.id
        match1.away_player_id = players.second.id
        match1.round = round
        match1.winner_id = players.second.id
        match1.home_score = 3
        match1.home_score = 4
        match1.played = true
        match1.save!

        # match2  player 3 won
        match2 = Match.new
        match2.home_player_id = players.third.id
        match2.away_player_id = players.fourth.id
        match2.round = round
        match2.winner_id = players.third.id
        match2.home_score = 4
        match2.home_score = 1
        match2.played = true
        match2.save!
      end

      it "creates a new round" do
        expect {subject.move_to_next_round}.to change(Round, :count).by(1)
      end

      it "assigns round to tournament" do
        subject.move_to_next_round
        subject.rounds.should_not be_empty
      end

      it "creates matches" do
        expect {subject.move_to_next_round}.to change(Match, :count).by(1)
      end

      it "assigns matches to current round" do
        subject.move_to_next_round
        round = subject.rounds.last

        round.matches.length.should == 1
      end

      it "assigns players to matches" do
        subject.move_to_next_round
        round = subject.rounds.last

        match = round.matches.first

        match.home_player_id.should == players.second.id
        match.away_player_id.should == players.third.id
      end
    end
  end
end
