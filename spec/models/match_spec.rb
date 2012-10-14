# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Match do
  it { should belong_to :round }
  it { should belong_to :home_player }
  it { should belong_to :away_player }
  it { should belong_to :winner }

  context "methods" do
    let(:match) { FactoryGirl.create(:match) }

    it "played should be false" do
      match.should_not be_played
    end

    context ".set_winner" do
      before(:each) do
        @home_player = FactoryGirl.create(:user)
        @away_player = FactoryGirl.create(:user)
        @match = FactoryGirl.create(:match, home_player: @home_player,
                                    away_player: @away_player)
      end


      it "should be winner the home player" do
        @match.away_score = 41
        @match.home_score = 23
        expect { @match.save }.to change { @match.winner }.from(nil).to(@away_player)
      end

      it "should be winner the away player" do
        @match.away_score = 11
        @match.home_score = 23
        expect { @match.save }.to change { @match.winner }.from(nil).to(@home_player)
      end

      it "should be nil for draw" do
        @match.away_score = 11
        @match.home_score = 11
        expect { @match.save }.to_not change { @match.winner }
      end
    end
  end

  context ".save" do
    let(:match) { FactoryGirl.build(:match) }
    it "creates match_hash" do
      expect { match.save }.to change { match.match_hash }.from(nil)
    end
  end
end

# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  round_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  matchdate      :datetime
#  match_hash     :string(255)
#  home_score     :integer
#  away_score     :integer
#  played         :boolean          default(FALSE)
#  home_player_id :integer
#  away_player_id :integer
#  winner_id      :integer
#

