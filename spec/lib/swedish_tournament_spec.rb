require 'spec_helper'

describe SwedishTournament do
  let(:user){FactoryGirl.create(:user)}

  subject {
    tournament = FactoryGirl.create(:tournament, :open, :swedish, {owner: user})
    tournament.extend SwedishTournament
  }

  context "moving to the next round" do
    let(:players){FactoryGirl.create_list(:user, 5)}

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
        expect {subject.move_to_next_round}.to change(Match, :count).by(3)
      end

      it "assigns matches to current round" do
        subject.move_to_next_round
        round = subject.rounds.last

        round.matches.length.should == 3
      end

      it "assigns players to matches" do
        subject.move_to_next_round
        round = subject.rounds.last
        matches = round.matches

        player_ids = players.map(&:id)
        # there is no strength so players will be in reverse order
        matches.first.home_player_id.should == players.fifth.id
        matches.first.away_player_id.should == players.fourth.id
        
        matches.second.home_player_id.should == players.third.id
        matches.second.away_player_id.should == players.second.id

        matches.third.home_player_id.should == players.first.id
        matches.third.winner_id.should == players.first.id
        matches.third.should be_played
      end
    end

    context "subsequent round" do
      before do
        round = Round.new
        round.active = true
        
        subject.rounds << round

        # now create the matches for the first round
        # match1  player 4 won
        match1 = Match.new
        match1.home_player_id = players.fifth.id
        match1.away_player_id = players.fourth.id
        match1.round = round
        match1.winner_id = players.fourth.id
        match1.home_score = 3
        match1.home_score = 4
        match1.played = true
        match1.save!

        # match2 player 3 won
        match2 = Match.new
        match2.home_player_id = players.third.id
        match2.away_player_id = players.second.id
        match2.round = round
        match2.winner_id = players.third.id
        match2.home_score = 4
        match2.home_score = 1
        match2.played = true
        match2.save!

        # match3 player 1 byeed
        match2 = Match.new
        match2.home_player_id = players.first.id
        match2.away_player_id = nil
        match2.round = round
        match2.winner_id = players.first.id
        match2.home_score = nil
        match2.home_score = nil
        match2.played = true
        match2.save!
      end

      it "deactivates the previous round" do
        subject.move_to_next_round
        subject.rounds.first.should_not be_active
      end

      it "creates a new round" do
        expect {subject.move_to_next_round}.to change(Round, :count).by(1)
      end

      it "marks new round as active" do 
        subject.move_to_next_round
        subject.rounds.last.should be_active
      end

      it "assigns round to tournament" do
        subject.move_to_next_round
        subject.rounds.length.should == 2
      end

      it "creates matches" do
        expect {subject.move_to_next_round}.to change(Match, :count).by(3)
      end

      it "assigns matches to current round" do
        subject.move_to_next_round
        round = subject.rounds.last

        round.matches.length.should == 3
      end

      it "assigns players to matches" do
        subject.move_to_next_round
        round = subject.rounds.last
        matches = round.matches

        player_ids = players.map(&:id)

        # after the first round players 4,3,1 have won so they should play 
        #  together. Probably 4 with 3, 1 with 2 or 5 and 5 byes
        match = matches.first

        match.home_player_id.should == players.first.id
        match.away_player_id.should == players.fourth.id

        match = matches.second

        match.home_player_id.should == players.third.id
        match.away_player_id.should == players.second.id

        match = matches.third

        match.home_player_id.should == players.fifth.id
        match.away_player_id.should_not be
        match.should be_played
 
      end
    end

  end
end
