FactoryGirl.define do
  factory :tournament do
    company
    #TODO: fix this when user factory is there
    owner_id 1
    description "There can be only one!"
    sequence(:name) {|x| "Tournament #{x}" }
    duration 5
    total_rounds 4
    round_duration 7

    # by default a CUP
    game_type Tournament::CUP
    description "There can be only one!"

    trait :cup do
      game_type Tournament::CUP
    end

    trait :league do
      game_type Tournament::LEAGUE
    end

    trait :swedish do
      game_type Tournament::SWEDISH
    end
  end
end
