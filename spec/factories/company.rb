FactoryGirl.define do
  factory :company do
    sequence(:domain) {|c| "The Kopanoi #{c}"}
  end
end
