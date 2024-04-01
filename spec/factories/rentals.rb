FactoryBot.define do
  factory :rental do
    car
    user
    customer { association :customer }
    rented_code { Date.today.year.to_s + SecureRandom.alphanumeric(11).upcase }
    daily_price { 234.56 }
    scheduled_start { 1.day.from_now }
    scheduled_end { 5.days.from_now }
    started_at { 1.days.from_now }
    status { :active }

    trait :finished do
      status { :finished }
      scheduled_start { 11.days.ago }
      scheduled_end { 1.days.ago }
      finished_at { 1.days.ago }
      started_at { 11.days.ago }
      ended_at { 1.days.ago }
    end

    trait :scheduled do
      status { :scheduled }
      scheduled_start { 1.day.from_now }
      scheduled_end { 5.days.from_now }
    end

    trait :canceled do
      scheduled_start { 1.day.from_now }
      scheduled_end { 5.days.from_now }
      started_at { Time.zone.now }
      ended_at { Time.zone.now }
      status { :canceled }
    end
    
    factory :scheduled_rental, traits: [:scheduled]
    factory :finished_rental, traits: [:finished]
    factory :canceled_rental, traits: [:canceled]
  end
end
