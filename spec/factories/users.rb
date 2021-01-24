FactoryBot.define do
  factory :user do
    name { "TestUser" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    activated { true }
    activated_at { Time.zone.now }

    trait :admin do
      admin { true }
    end

    trait :no_activated do
      activated { false }
      activated_at { nil }
    end

    trait :with_posts do
      after(:create) { |user| create_list(:post, 5, user: user) }
    end
  end
end
