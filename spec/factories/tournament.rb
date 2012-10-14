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
    status Tournament::PENDING

    # by default a CUP
    game_type Tournament::CUP

    trait :cup do
      game_type Tournament::CUP
    end

    trait :league do
      game_type Tournament::LEAGUE
    end

    trait :swedish do
      game_type Tournament::SWEDISH
    end

    trait :pending do
      status Tournament::PENDING
    end

    trait :open do
      status Tournament::OPEN
    end

    trait :closed do
      status Tournament::CLOSED
    end

  end
end
