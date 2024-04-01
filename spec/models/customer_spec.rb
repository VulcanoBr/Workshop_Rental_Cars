# spec/models/customer_spec.rb
require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it 'should require name, email, and phone' do
      customer = build(:customer, name: nil, email: nil, phone: nil)
      expect(customer).not_to be_valid
      expect(customer.errors[:name]).to include("não pode ficar em branco")
      expect(customer.errors[:email]).to include("não pode ficar em branco")
      expect(customer.errors[:phone]).to include("não pode ficar em branco")
    end
  end

  describe 'methods' do
    it 'should return a description in the format "ID - Name"' do
      customer = create(:customer, name: 'John Doe')
      expect(customer.description).to eq("John Doe - ")
    end

    it 'should return the last active rental' do
      customer = create(:customer)
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(true)
      active_rental = create(:rental, customer: customer, status: :scheduled)
      expect(customer.active_rental?).to eq(true)
    end

    it 'should return nil if there are no active rentals' do
      customer = create(:customer)
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      active_rental = create(:rental, customer: customer, status: :finished)
      expect(customer.active_rental?).to eq(false)
    end
  end
end
