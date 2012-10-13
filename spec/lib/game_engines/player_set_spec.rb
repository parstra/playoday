require 'spec_helper'

describe GameEngines::PlayerSet do

  let(:player_id){10}
  let(:attrs){{last_win: true, strength: 1.3, bye: false, opponent_ids: [3,4,5]}}

  subject {GameEngines::PlayerSet.new(player_id, attrs)}

  context "initializing" do
    it "assigns player id" do
      subject.id.should == player_id
    end

    it "assigns strength" do
      subject.strength.should == 1.3
    end

    it "assigns bye" do
      subject.bye.should == false
    end

    it "assigns opponent_ids" do
      subject.opponent_ids.should == [3,4,5]
    end

    it "last win" do
      subject.last_win.should == true
    end
  end

  # this only makes sence for knock out games
  context "round checking" do
    context "last win is null" do
      let(:attrs){{}}

      it {should be_first_round}
      it {should_not have_won}
      it {should_not have_lost}
    end

    context "last win is false" do
      let(:attrs){{last_win: false}}

      it {should_not be_first_round}
      it {should_not have_won}
      it {should have_lost}
    end

    context "last win is true" do
      let(:attrs){{last_win: true}}

      it {should_not be_first_round}
      it {should have_won}
      it {should_not have_lost}
    end
  end
end
