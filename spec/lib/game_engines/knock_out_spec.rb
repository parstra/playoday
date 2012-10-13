require 'spec_helper'

describe GameEngines::KnockOut do

  subject {GameEngines::KnockOut.new(player_set)}

  context "playability" do

    context "first_round" do
      context "power of two players" do
        let(:player_set){
          [
            GameEngines::PlayerSet.new(1),
            GameEngines::PlayerSet.new(2),
            GameEngines::PlayerSet.new(3),
            GameEngines::PlayerSet.new(4, last_win: false)
          ]
        }

        it {should be_playable}
      end

      context "power of two minus one players" do
        let(:player_set){
          [
            GameEngines::PlayerSet.new(1),
            GameEngines::PlayerSet.new(2),
            GameEngines::PlayerSet.new(3),
            GameEngines::PlayerSet.new(4, last_win: false),
            GameEngines::PlayerSet.new(5),
            GameEngines::PlayerSet.new(6),
            GameEngines::PlayerSet.new(7),
          ]
        }

        it {should be_playable}
      end

      context "not a power of two" do
       let(:player_set){
          [
            GameEngines::PlayerSet.new(1),
            GameEngines::PlayerSet.new(2),
            GameEngines::PlayerSet.new(3),
            GameEngines::PlayerSet.new(4, last_win: false),
            GameEngines::PlayerSet.new(5),
            GameEngines::PlayerSet.new(6)
          ]
        }

        it {should_not be_playable}
      end
    end

    context "subsequent round" do
      context "power of two players" do
        let(:player_set){
          [
            GameEngines::PlayerSet.new(1, last_win: false),
            GameEngines::PlayerSet.new(2, last_win: true),
            GameEngines::PlayerSet.new(3, last_win: false),
            GameEngines::PlayerSet.new(4, last_win: true)
          ]
        }

        it {should be_playable}
      end

      context "power of two minus one players" do
        let(:player_set){
          [
            GameEngines::PlayerSet.new(1, last_win: false),
            GameEngines::PlayerSet.new(2, last_win: true),
            GameEngines::PlayerSet.new(3, last_win: false),
            GameEngines::PlayerSet.new(4, last_win: true),
            GameEngines::PlayerSet.new(5, last_win: false),
            GameEngines::PlayerSet.new(6, last_win: true),
            GameEngines::PlayerSet.new(7, last_win: false),
          ]
        }

        it {should_not be_playable}
      end

      context "not a power of two" do
       let(:player_set){
          [
            GameEngines::PlayerSet.new(1, last_win: false),
            GameEngines::PlayerSet.new(2, last_win: true),
            GameEngines::PlayerSet.new(3, last_win: false),
            GameEngines::PlayerSet.new(4, last_win: true),
            GameEngines::PlayerSet.new(5, last_win: false),
            GameEngines::PlayerSet.new(6, last_win: true),
          ]
        }

        it {should_not be_playable}
      end
    end
  end

  context "round checking" do
    context "round is first" do
      let(:player_set){
        [
          GameEngines::PlayerSet.new(1),
          GameEngines::PlayerSet.new(2),
          GameEngines::PlayerSet.new(3),
          GameEngines::PlayerSet.new(4, last_win: false)
        ]
      }

      it "resolves to first round with all last_game_win are nil or false" do
        subject.should be_first_round
      end
    end
  end

  context "drawing" do
    context "first round" do
      context "power of two players" do
        let(:player_set){
          [
            GameEngines::PlayerSet.new(1),
            GameEngines::PlayerSet.new(2),
            GameEngines::PlayerSet.new(3),
            GameEngines::PlayerSet.new(4),
          ]
        }

        it "assigns matches to players with no byes" do
          subject.draw.should == [[1,2], [3,4]]
        end
      end

      context "power of two minus one players" do
       let(:player_set){
          [
            GameEngines::PlayerSet.new(1),
            GameEngines::PlayerSet.new(2),
            GameEngines::PlayerSet.new(3),
            GameEngines::PlayerSet.new(4),
            GameEngines::PlayerSet.new(5),
            GameEngines::PlayerSet.new(6),
            GameEngines::PlayerSet.new(7),
          ]
        }

        it "assigns matches to players, last one goes bye" do
          subject.draw.should == [[1,2], [3,4], [5,6], [7,nil]]
        end
      end
    end

    context "subsequent round" do
      context "power of two players" do
        let(:player_set){
          [
            GameEngines::PlayerSet.new(1, last_win: false),
            GameEngines::PlayerSet.new(2, last_win: true),
            GameEngines::PlayerSet.new(3, last_win: true),
            GameEngines::PlayerSet.new(4, last_win: false)
          ]
        }


        it "assigns matches to players that won the last match" do
          subject.draw.should == [[2,3]]
        end
      end
    end
  end
end
