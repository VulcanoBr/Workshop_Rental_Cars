FactoryBot.define do
  factory :manufacture do
    sequence(:name) { |m| "Matbraga#{m}" }
  end
end
