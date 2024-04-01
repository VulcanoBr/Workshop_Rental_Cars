require 'rails_helper'

RSpec.describe RentalByPeriodQuery do 
  describe 'call' do
    it 'should return cars in a range' do
      subsidiary = create(:subsidiary)
      car = create(:car, subsidiary: subsidiary)
      customer_company = create(:company_customer, email: 'lucas@gmail.com')
      customer_personal = create(:personal_customer, email: 'lucas@gmail.com')
      other_subsidiary = create(:subsidiary)
      other_car = create(:car, subsidiary: other_subsidiary)
      
      original_date = Date.today

      past_date = Date.new(2023, 1, 1)

      allow(Date).to receive(:today).and_return(past_date)

      start = Date.today
      finish = Date.today + 10

      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      create_list(:finished_rental, 10, car: car, customer_id: customer_company.id, finished_at: Date.today + 9,
              scheduled_start: start, scheduled_end: finish, started_at: start, ended_at: finish )
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      create_list(:finished_rental, 5, car: other_car, customer_id: customer_personal.id, finished_at: Date.today + 9,
                scheduled_start: start, scheduled_end: finish, started_at: start, ended_at: finish)
      
      result =  RentalByPeriodQuery.new(start, finish).call
      expect(result[car.id]).to eq 10
      expect(result[other_car.id]).to eq 5
    end
  
    it 'should return cars nil' do
      start = Date.today
      finish = Date.today + 10
      
      create(:subsidiary)
      car = create(:car)
      customer = create(:personal_customer, email: 'lucas@gmail.com')
      other_subsidiary = create(:subsidiary)
      other_car = create(:car, subsidiary: other_subsidiary)
      
      build_list(:finished_rental, 10, car: car, customer_id: customer.id, finished_at: Date.today + 10,
        status: :finished, scheduled_start: start, scheduled_end: finish, started_at: start, ended_at: finish)
      build_list(:finished_rental, 5, car: other_car, customer_id: customer.id, finished_at: Date.today + 10,
      status: :finished, scheduled_start: start, scheduled_end: finish, started_at: start, ended_at: finish)
      
      result =  RentalByPeriodQuery.new(start, finish).call
      
      expect(result[car.id]).to eq nil
      expect(result[other_car.id]).to eq nil
    end
  end
end
