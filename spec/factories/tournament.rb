FactoryGirl.define do
  factory :tournament do
    company
    owner_id 1
    game_type 1
    description "There can be only one!"
    sequence(:name) {|x| "Tournament #{x}" }
    duration 5
    total_rounds 4
    round_duration 7
  end
end
