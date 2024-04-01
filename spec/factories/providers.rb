FactoryBot.define do
  factory :provider do
    name { 'MyString' }
    cnpj { '18.187.641/0001-62' }
    email { 'sanurai@rental.com'}
    phone { '(21) 9 7654-3456'}
  end
end
