require 'spec_helper'

describe GameEngines::Swedish do

  subject {GameEngines::Swedish.new(player_set)}

  context "drawing" do
    context "bye-ing a player" do
      let(:player_set){
        [
          GameEngines::PlayerSet.new(1, strength: 2,
                                        bye: false,
                                        opponent_ids: []),
          GameEngines::PlayerSet.new(2, strength: 2,
                                        bye: false,
                                        opponent_ids: []),
          GameEngines::PlayerSet.new(3, strength: 2,
                                        bye: false,
                                        opponent_ids: [])
        ]
      }

      it {should be_byeable}

      context "when no one has byed before" do
        it "has one player bye when drawing" do
          subject.to_be_byeed_id.should be
        end
      end

      context "when some players have byed" do
        let(:player_set){
          [
            GameEngines::PlayerSet.new(1, strength: 2,
                                          bye: false,
                                          opponent_ids: []),
            GameEngines::PlayerSet.new(2, strength: 2,
                                          bye: true,
                                          opponent_ids: []),
            GameEngines::PlayerSet.new(3, strength: 2,
                                          bye: true,
                                          opponent_ids: [])
          ]
        }

        it "byes players that have not byed before" do
          subject.to_be_byeed_id.should == 1
        end
      end

      context "when number of players is even" do
        let(:player_set){
          [
            GameEngines::PlayerSet.new(1, strength: 2,
                                          opponent_ids: []),
            GameEngines::PlayerSet.new(2, strength: 2,
                                          opponent_ids: []),
            GameEngines::PlayerSet.new(3, strength: 2,
                                          opponent_ids: []),
            GameEngines::PlayerSet.new(4, strength: 2,
                                          opponent_ids: [])
          ]
        }

        it {should_not be_byeable}
      end
    end

    context "selecting pairs" do
      context "even number of players" do
        context "when pairs have not met before" do
          let(:player_set){
            [
              GameEngines::PlayerSet.new(1, strength: 5,
                                            opponent_ids: []),
              GameEngines::PlayerSet.new(2, strength: 11,
                                            opponent_ids: []),
              GameEngines::PlayerSet.new(3, strength: 3,
                                            opponent_ids: []),
              GameEngines::PlayerSet.new(4, strength: 1,
                                            opponent_ids: [])
            ]
          }

          it "pairs by score" do
            subject.draw.should == [[2,1], [3,4]]
          end
        end

        context "when pairs have met before" do
          let(:player_set){
            [
              GameEngines::PlayerSet.new(1, strength: 5,
                                            opponent_ids: [2]),
              GameEngines::PlayerSet.new(2, strength: 11,
                                            opponent_ids: [1]),
              GameEngines::PlayerSet.new(3, strength: 3,
                                            opponent_ids: [4]),
              GameEngines::PlayerSet.new(4, strength: 1,
                                            opponent_ids: [3])
            ]
          }

          # Normally player 1 should play with player 2 but they have already
          #  played in the past. The next available (by score) not previously
          #  selected player will be picked
          it "pairs by score" do
            subject.draw.should == [[2,3], [1,4]]
          end
        end
      end

      context "odd number of players" do
        context "when pairs have not met before" do
          let(:player_set) {
            [
               GameEngines::PlayerSet.new(1, strength: 5,
                                             opponent_ids: []),
               GameEngines::PlayerSet.new(2, strength: 11,
                                             opponent_ids: []),
               GameEngines::PlayerSet.new(3, strength: 3,
                                             opponent_ids: []),
               GameEngines::PlayerSet.new(4, strength: 1,
                                             bye: true,
                                             opponent_ids: []),
               GameEngines::PlayerSet.new(5, strength: 9,
                                             opponent_ids: [])
              ]
          }

          # normally 4 would be byeed but he has already so 3 is picked
          # 2, 5 is pair 1
          # 1, 4 is pair 2
          # 3 is bye
          it "pairs by score" do
            subject.draw.should == [[2,5], [1,4], [3, nil]]
          end
        end

        context "when pairs have met before" do
          let(:player_set) {
            [
               GameEngines::PlayerSet.new(1, strength: 5,
                                             opponent_ids: [4]),
               GameEngines::PlayerSet.new(2, strength: 11,
                                             opponent_ids: [5]),
               GameEngines::PlayerSet.new(3, strength: 3,
                                             bye: true,
                                             opponent_ids: []),
               GameEngines::PlayerSet.new(4, strength: 1,
                                             opponent_ids: [1]),
               GameEngines::PlayerSet.new(5, strength: 9,
                                             opponent_ids: [2])
              ]
          }

          # 2, 1 is pair 1
          # 5, 3 is pair 2
          # 4 is bye
          it "pairs by score" do
            subject.draw.should == [[2,1], [5,3], [4, nil]]
          end

        end
      end

    end
  end
end
