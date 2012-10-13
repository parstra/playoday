FactoryGirl.define do
  factory :round do
    tournament
    active false

    trait :active do
      active true
    end

    factory :active_round, traits: [:active]
  end
end
