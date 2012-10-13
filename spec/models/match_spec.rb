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

    it "create_match_hash! should populate match_hash with a md5 digest" do
      expect { match.create_match_hash! }.to change { match.match_hash }
    end
  end
end

