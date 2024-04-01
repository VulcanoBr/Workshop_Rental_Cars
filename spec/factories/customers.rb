FactoryBot.define do
  factory :customer do
    name { 'Vulcano Sanurai' }
    email { 'vulcan@gmail.com' }
    cpf { '624.299.657-04' }
    phone { '11 999990000' }
  end
  factory :personal_customer do
    name { 'Jose Silva' }
    email { 'jose@gmail.com' }
    cpf { '024.714.660-95' }
    phone { '11 999990000' }
    type { 'PersonalCustomer'}
  end
  factory :company_customer do
    name { 'ACME Inc' }
    fantasy_name { 'ACME Inc' }
    email { 'acme@gmail.com' }
    phone { '11 99990000' }
    cnpj { '18.187.641/0001-62' }
    type { 'CompanyCustomer'}
  end
end
