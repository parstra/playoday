# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Tournament do

  it { should have_many :rounds }
  it { should belong_to :company }
  it { should belong_to :owner }
  it { should have_many(:users).through(:tournament_users) }

  it { should validate_presence_of :name }
  it { should validate_numericality_of :game_type }
  it { should validate_presence_of :owner_id }

#  it { should validate_presence_of :duration }
#  it { should validate_presence_of :total_rounds }
#  it { should validate_presence_of :round_duration }
#  it { should validate_presence_of :company_id }

  context "methods" do
    let(:active_tournament) { FactoryGirl.create(:tournament, active: true) }
    let(:inactive_tournament) { FactoryGirl.create(:tournament, active: false) }

    let(:tournament) { FactoryGirl.create(:tournament, active: true) }
    let!(:rounds) { FactoryGirl.create_list(:round, 5, tournament: tournament) }
    let!(:active_round) { FactoryGirl.create(:active_round, tournament: tournament) }

    it ".active" do
      active_tournament.should be_active
      inactive_tournament.should_not be_active
    end

    it "active_round" do
      tournament.active_round.should == active_round
    end
  end

  context "before create" do
    let(:new_tournament) { FactoryGirl.build(:tournament) }

    it "should set a tournament hash" do
      expect { new_tournament.save }.
        to change { new_tournament.tournament_hash }.from(nil)
      new_tournament.tournament_hash.length.should == 32
    end
  end

  context "starting a tournament" do
    let(:user){FactoryGirl.create(:user)}

    context "checking if it can be opened" do
      context "when in pending mode" do
        before {subject.status = Tournament::PENDING}
        it {should be_openable}
      end

      context "when in open mode" do
        before {subject.status = Tournament::OPEN}
        it {should_not be_openable}
      end

      context "when in closed mode" do
        before {subject.status = Tournament::CLOSED}
        it {should_not be_openable}
      end
    end

    context "that is already open" do
      before {subject.status = Tournament::OPEN}
      it "doesn't start" do
        expect {subject.start}.to raise_error(TournamentCannotOpen)
      end
    end

    context "that has less than 2 players" do
      before {
        subject.status = Tournament::PENDING
      }

      it "doesn't start" do
        expect {subject.start}.to raise_error(NotEnoughPlayers)
      end
    end

    context "cup tournament" do
      context "that is pending and has at least two players" do
        subject {FactoryGirl.build(:tournament, :pending, :cup, {owner: user})}

        before {
          subject.users << FactoryGirl.create_list(:user, 4)
          subject.save!
        }

        it "moves status to open" do
          subject.start
          subject.reload.status.should == Tournament::OPEN
        end

        it "creates a round" do
          expect {subject.start}.to change(Round, :count).by(1)
        end

        it "saves total rounds depending on the number of players" do
          subject.start
          subject.total_rounds.should == 2
        end

      end
    end

    context "swedish tournament" do
      context "that is pending and has at least two players" do
        subject {FactoryGirl.build(:tournament, :pending, :swedish, {owner: user})}

        before {
          subject.users << FactoryGirl.create_list(:user, 4)
          subject.save!
        }

        it "moves status to open" do
          subject.start
          subject.reload.status.should == Tournament::OPEN
        end

        it "creates a round" do
          expect {subject.start}.to change(Round, :count).by(1)
        end

      end
    end
  end

  context "moving to the next round" do
    subject {FactoryGirl.create(:tournament, :pending, :cup)}
    context "when tournament not open yet" do
      it "raises exception" do
        expect{subject.next_round}.to raise_error(TournamentNotOpenYet)
      end
    end

    context "when tournament is open" do
      before do
        subject.status = Tournament::OPEN
      end

      it "creates a round" do
        expect {subject.next_round}.to change(Round, :count).by(1)
      end
    end

    context "when total rounds have been played" do
      subject {FactoryGirl.create(:tournament, :pending, :cup)}

      before {
        subject.users << FactoryGirl.create_list(:user, 2)
        subject.start
      }

      it "raises exception that there are no more rounds" do
        expect {subject.next_round}.to raise_error(TournamentAllRoundsPlayed)
      end
    end
  end

  context "leaderboard" do
    subject {FactoryGirl.create(:tournament, :pending, :swedish)}

    before {
      subject.users << FactoryGirl.create_list(:user, 4)
      subject.start

      round = subject.rounds.last

      round.matches.each do |m|
        m.played = true
        m.winner_id = m.home_player_id
        m.save!
      end

      subject.next_round
    }

    it "calculates leaderboard players" do
      users = subject.users

      subject.leaderboard.map(&:player).map(&:id).should ==
        [users.fourth, users.second, users.third, users.first].map(&:id)
    end

    it "calculates leaderboard wins" do
      users = subject.users

      subject.leaderboard.map(&:wins).should ==
        [1, 1, 0, 0]
    end

    it "calculates leaderboard losses" do
      users = subject.users

      subject.leaderboard.map(&:losses).should ==
        [0, 0, 1, 1]
    end


  end


end


# == Schema Information
#
# Table name: tournaments
#
#  id              :integer          not null, primary key
#  description     :string(255)      not null
#  tournament_hash :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_type       :integer
#  company_id      :integer
#  owner_id        :integer
#  name            :string(255)
#  duration        :integer
#  total_rounds    :integer
#  round_duration  :integer
#  active          :boolean          default(FALSE)
#  started_at      :datetime
#

