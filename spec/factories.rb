# User factory
FactoryGirl.define do
  factory :user do
    name "Stephen Harper"
    email "pm@gov.ab.ca"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :micropost do
    content "Foo bar"
    association :user
  end

  sequence :email do |n|
    "person-#{n}@example.com"
  end
end
