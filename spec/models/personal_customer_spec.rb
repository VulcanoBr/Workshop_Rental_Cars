require 'rails_helper'

RSpec.describe PersonalCustomer, type: :model do
  describe '#personal_customer validates' do
    it 'should require cpf' do
      personal_customer = PersonalCustomer.new(cpf: nil)
      expect(personal_customer).not_to be_valid
      expect(personal_customer.errors[:cpf]).to include('não pode ficar em branco')
    end

    it 'should validate cpf format false' do
      personal_customer = PersonalCustomer.new(cpf: '1234567890123')
      personal_customer.valid?  # Dispara a validação
      expect(personal_customer).not_to be_valid
      expect(personal_customer.errors[:cpf]).to include("Inválido")
    end

    it 'should validate uniqueness of cpf' do
      FactoryBot.create(:personal_customer, cpf: '624.299.657-04')
      personal_customer2 = build(:personal_customer, cpf: '624.299.657-04')
      expect(personal_customer2).not_to be_valid
      expect(personal_customer2.errors[:cpf]).to include("já está em uso")
    end
  end

  describe '#personal_customer?' do
    it 'returns true' do
      personal_customer = build(:personal_customer)
      expect(personal_customer.personal_customer?).to be true
    end
  end

  describe '#company_customer?' do
    it 'returns false' do
      personal_customer = build(:personal_customer)
      expect(personal_customer.company_customer?).to be false
    end
  end
end

