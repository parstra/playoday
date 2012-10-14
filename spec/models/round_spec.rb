# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Round do
  it { should belong_to :tournament }
  it { should have_many :matches }

  context "scopes" do
    let!(:active_rounds) { FactoryGirl.create_list(:active_round, 5) }
    let!(:inactive_rounds) { FactoryGirl.create_list(:round, 2) }
    it "active should fetch only active rounds" do
      Round.active.collect(&:id).should == active_rounds.collect(&:id)
      (Round.active.collect(&:id) & inactive_rounds.collect(&:id)).should be_empty
    end
  end

  context "round closing" do
    let(:players){FactoryGirl.create_list(:user, 4)}
    subject{FactoryGirl.create(:round, :active)}

    before do
      m = Match.new
      m.home_player = players.first
      m.away_player = players.second
      subject.matches << m

      m = Match.new
      m.home_player = players.third
      m.away_player = players.fourth
      subject.matches << m
    end

    context "when all matches are played" do
      before do
        subject.matches.each do |m|
          m.winner = m.home_player
          m.played = true
          m.home_score = 1
          m.away_score = 0
          m.save
        end
      end

      it {should be_closable}
    end

    context "when not all matches are played" do
      before do
        m = subject.matches.first
        m.winner = m.home_player
        m.played = true
        m.home_score = 1
        m.away_score = 0
        m.save
      end

      it {should_not be_closable}
    end
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id            :integer          not null, primary key
#  tournament_id :integer          not null
#  round_number  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  started_at    :datetime
#  ended_at      :datetime
#  active        :boolean
#

