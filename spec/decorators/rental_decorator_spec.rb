require 'rails_helper'

RSpec.describe RentalDecorator do 

  describe '#started_at' do
    
    it 'should return --- for a scheduled rental' do
      
      car = create(:car)
      personal_customer = create(:personal_customer)
      
      rental = build(:rental, customer: personal_customer, car: car, status: :scheduled)
      result = rental.decorate.started_at

      expect(result).to eq '---'
    end

    it 'should return started_at for a active rental' do
      car = create(:car)
      personal_customer = create(:personal_customer)
      
      rental = build(:rental, customer: personal_customer, car: car, started_at: '21/08/2020')

      result = rental.decorate.started_at

      expect(result).to eq '21/08/2020'
    end
  end
end