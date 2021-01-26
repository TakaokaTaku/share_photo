FactoryBot.define do
  factory :post do
    content { "post test" }
    created_at { 10.minutes.ago }
    association :user

    trait :yesterday do
      content { "yesterday" }
      created_at { 1.day.ago }
    end

    trait :day_before_yesterday do
      content { "day_before_yesterday" }
      created_at { 2.days.ago }
    end

    trait :now do
      content { "now!" }
      created_at { Time.zone.now }
    end

    after(:build) do |post|
      post.image.attach(io: File.open('spec/fixtures/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpeg')
    end
  end
end
