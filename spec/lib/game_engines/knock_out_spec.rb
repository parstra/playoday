require 'spec_helper'

describe GameEngines::KnockOut do

  subject {GameEngines::KnockOut.new(player_set)}

  context "playability" do

    context "first_round" do
      context "power of two players" do
        let(:player_set){
          [[1, nil],
           [2, nil],
           [3, nil],
           [4, nil]]
        }

        it {should be_playable}
      end

      context "power of two minus one players" do
        let(:player_set){
          [[1, nil],
           [2, nil],
           [3, nil],
           [4, nil],
           [5, nil],
           [6, nil],
           [7, nil]]
        }

        it {should be_playable}
      end

      context "not a power of two" do
        let(:player_set){
          [[1, nil],
           [2, nil],
           [3, nil],
           [5, nil],
           [6, nil],
           [7, nil]]
        }

        it {should_not be_playable}
      end
    end

    context "subsequent round" do
      context "power of two players" do
        let(:player_set){
          [[1, true],
           [2, nil],
           [3, true],
           [4, nil]]
        }

        it {should be_playable}
      end

      context "power of two minus one players" do
        let(:player_set){
          [[1, true],
           [2, nil],
           [3, true],
           [4, nil],
           [5, true],
           [6, nil],
           [7, true]]
        }

        it {should_not be_playable}
      end

      context "not a power of two" do
        let(:player_set){
          [[1, nil],
           [2, true],
           [3, nil],
           [5, true],
           [6, nil],
           [7, true]]
        }

        it {should_not be_playable}
      end
    end
  end

  context "round checking" do
    context "round is first" do
      let(:player_set){
        [[1, nil],
         [2, nil],
         [3, nil],
         [4, false]]
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
          [[1, nil],
           [2, nil],
           [3, nil],
           [4, nil]]
        }

        it "assigns matches to players with no byes" do
          subject.draw.should == [[1,2], [3,4]]
        end
      end

      context "power of two minus one players" do
        let(:player_set){
          [[1, nil],
           [2, nil],
           [3, nil],
           [4, nil],
           [5, nil],
           [6, nil],
           [7, nil]]
        }

        it "assigns matches to players, last one goes bye" do
          subject.draw.should == [[1,2], [3,4], [5,6], [7,nil]]
        end
      end
    end

    context "subsequent round" do
      context "power of two players" do
        let(:player_set){
          [[1, false],
           [2, true],
           [3, true],
           [4, false]]
        }

        it "assigns matches to players that won the last match" do
          subject.draw.should == [[2,3]]
        end
      end
    end
  end
end
