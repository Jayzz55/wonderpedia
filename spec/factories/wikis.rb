FactoryGirl.define do
  factory :wiki do
    title "test one"
    body "hello world"

    factory :wiki_with_user do

      transient do
        user { create :user }
      end

      after :create do |wiki, evaluator|
        wiki.users << evaluator.user
        wiki.save
        wiki_user = wiki.collaborators.where(user: evaluator.user).first
        wiki_user.save
      end
    end
  end

end
