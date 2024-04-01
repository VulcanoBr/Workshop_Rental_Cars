FactoryBot.define do
  factory :car_model do
    name { 'Mustang LX' }
    year { '2008' }
    manufacture
    car_options { '3 portas' }
    category { 'Standard' }
  end
end
