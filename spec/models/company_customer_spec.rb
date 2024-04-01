require 'rails_helper'

RSpec.describe CompanyCustomer, type: :model do

  describe '#company_customer validates' do
    it 'should require cnpj' do
      company_customer = CompanyCustomer.new(cnpj: nil)
      expect(company_customer).not_to be_valid
      expect(company_customer.errors[:cnpj]).to include('não pode ficar em branco')
    end

    it 'should validate cnpj format false' do
      company_customer = CompanyCustomer.new(cnpj: '1234567890123')
      company_customer.valid?  # Dispara a validação
      expect(company_customer).not_to be_valid
      expect(company_customer.errors[:cnpj]).to include("Inválido")
    end

    it 'should validate uniqueness of cnpj' do
      FactoryBot.create(:company_customer, cnpj: '18.187.641/0001-62')
      company_customer2 = build(:company_customer, cnpj: '18.187.641/0001-62')
      expect(company_customer2).not_to be_valid
      expect(company_customer2.errors[:cnpj]).to include("já está em uso")
    end
  end

  describe '#personal_customer?' do
    it 'returns false' do
      company_customer = build(:company_customer)
      expect(company_customer.personal_customer?).to be false
    end
  end

  describe '#company_customer?' do
    it 'returns true' do
      company_customer = build(:company_customer)
      expect(company_customer.company_customer?).to be true
    end
  end
end
