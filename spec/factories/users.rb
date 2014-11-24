FactoryGirl.define do
  factory :user do
    sequence(:name, 100) { |n| "John Testing#{n}" }
    sequence(:email, 100) { |n| "person#{n}@example.com" }
    password "helloworld"
    password_confirmation "helloworld"
    confirmed_at Time.now
    premium false

    factory :user_with_wiki do

      transient do
        wiki { create :wiki }
        wiki_title "test one"
        wiki_body "hello world"
      end

      after :create do |user, evaluator|
        evaluator.wiki.update_attributes(title: evaluator.wiki_title, body: evaluator.wiki_body)
        user.wikis << evaluator.wiki
        user.save
        user_wiki = user.collaborators.where(wiki: evaluator.wiki).first
        user_wiki.save
      end
    end
  end
end
