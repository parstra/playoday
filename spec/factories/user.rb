FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@playoday.com"
  end

  factory :user do
    email
    password "123456"
  end
end
