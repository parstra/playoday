FactoryGirl.define do
  factory :company do
    sequence(:name) {|c| "The Kopanoi #{c}"}
  end
end
