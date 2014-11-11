 FactoryGirl.define do
  factory :user do
    name "John Testing"
    sequence(:email, 100) { |n| "person#{n}@example.com" }
    password "helloworld"
    password_confirmation "helloworld"
    confirmed_at Time.now
    premium false
  end
 end
