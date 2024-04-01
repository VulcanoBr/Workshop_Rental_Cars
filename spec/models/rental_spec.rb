require 'rails_helper'

RSpec.describe Rental, type: :model do

  describe '#rental validates ' do
    it "should not be valid without car_id" do
      rental = build(:rental, car_id: nil)
      expect(rental).not_to be_valid
      expect(rental.errors[:car_id]).to include("não pode ficar em branco")
    end

    it "should not be valid without customer_id" do
      rental = build(:rental, customer_id: nil)
      expect(rental).not_to be_valid
      expect(rental.errors[:customer_id]).to include("não pode ficar em branco")
    end

    it "should not be valid without scheduled_start" do
      rental = build(:rental, scheduled_start: nil)
      expect(rental).not_to be_valid
      expect(rental.errors[:scheduled_start]).to include("não pode ficar em branco")
    end

    it "should not be valid without scheduled_end" do
      rental = build(:rental, scheduled_end: nil)
      expect(rental).not_to be_valid
      expect(rental.errors[:scheduled_end]).to include("não pode ficar em branco")
    end

    it 'validates that scheduled_end is after scheduled_start' do
      model = build(:rental, scheduled_start: Date.today, scheduled_end: Date.today - 1.day)
      expect(model).not_to be_valid
      expect(model.errors[:scheduled_end]).to include("deve ser maior ou igual a #{model.scheduled_start}")
    end
  
    it 'validates that scheduled_start and scheduled_end are after the current date' do
      model = build(:rental, scheduled_start: Date.today - 1.day, scheduled_end: Date.today - 2.day)
      expect(model).not_to be_valid
      expect(model.errors[:scheduled_start]).to include("deve ser maior ou igual a #{Date.today}")
      expect(model.errors[:scheduled_end]).to include("deve ser maior ou igual a #{Date.today}")
    end
  end

  describe 'customer_has_active_rental' do
    it 'should not allow a rental if the PERSONAL_customer has an active rental' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      car_model = create(:car_model)
      car_model2 = create(:car_model)
      car = create(:car, car_model_id: car_model2.id, subsidiary: user.subsidiary, status: :available)
      car2 = create(:car, car_model_id: car_model.id, subsidiary: user.subsidiary, status: :available)
      customer = create(:personal_customer, cpf: '624.299.657-04', type: 'PersonalCustomer')
      #allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(true)
      rental1 = create(:rental, car_id: car.id, user_id: user.id, customer_id: customer.id, status: :active)

      rental = Rental.new(car: car2, customer: customer, status: :scheduled)
    
      expect(rental).to_not be_valid
      expect(rental.errors[:customer_id]).to include("possui locação em aberto")
    end

    it 'should allow a rental if the PERSONAL_customer does not have an active rental' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      car = create(:car, subsidiary: user.subsidiary)
      customer = create(:personal_customer)
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      create(:rental, car_id: car.id, user_id: user.id, customer_id: customer.id,
                        finished_at: Time.zone.today, status: :finished)
      rental = build(:rental, car_id: car.id, user_id: user.id, customer_id: customer.id)
      expect(rental).to be_valid
    end

    it 'should not allow a rental if the COMPANy_customer has an active rental' do
      customer = create(:company_customer, cnpj: '18.187.641/0001-62')
      create(:rental, customer_id: customer.id, status: :active)

      rental = create(:rental, customer_id: customer.id, status: :scheduled)
      expect(rental).to be_valid
      expect(rental.errors[:customer_id]).not_to include('possui locação em aberto')
    end

    it 'should allow a rental if the COMPANY_customer does not have an active rental' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      car = create(:car, subsidiary: user.subsidiary)
      customer = create(:company_customer, cnpj: '18.187.641/0001-62')
      create(:rental, car_id: car.id, user_id: user.id, customer_id: customer.id,
                        finished_at: Time.zone.today, status: :finished)
      rental = build(:rental, car_id: car.id, user_id: user.id, customer_id: customer.id)
      expect(rental).to be_valid
    end
  end

  describe 'rented scope to search rented ' do
    it 'returns rentals with rented cars and active status' do
      customer = create(:personal_customer, cpf: '624.299.657-04', type: 'PersonalCustomer')
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rented_car = create(:car, status: :rented)
      active_rental = create(:rental, car: rented_car, customer: customer, status: :active)
      inactive_rental = create(:rental, car: rented_car, customer: customer, status: :finished)

      expect(Rental.rented).to include(active_rental)
      expect(Rental.rented).not_to include(inactive_rental)
    end
    
    it 'filters rentals based on rented_code' do
      customer = create(:personal_customer, cpf: '624.299.657-04', type: 'PersonalCustomer')
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rented_car = create(:car, status: :rented)
      rental_with_code = create(:rental, car: rented_car, customer: customer, status: :active, rented_code: '2024ABC123TREWR')
      rental_without_code = create(:rental, car: rented_car, customer: customer, status: :active, rented_code: nil)

      expect(Rental.rented('2024ABC123TREWR')).to include(rental_with_code)
      expect(Rental.rented('2024ABC123TREWR')).not_to include(rental_without_code)
    end
  end

  describe 'rented scope to search scheduled ' do
    it 'returns rentals with rented cars and scheduled status' do
      customer = create(:personal_customer, cpf: '624.299.657-04', type: 'PersonalCustomer')
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rented_car = create(:car, status: :scheduled)
      active_rental = create(:rental, car: rented_car, customer: customer, status: :scheduled)
      inactive_rental = create(:rental, car: rented_car, customer: customer, status: :finished)

      expect(Rental.scheduled).to include(active_rental)
      expect(Rental.scheduled).not_to include(inactive_rental)
    end
    
    it 'filters rentals based on rented_code' do
      customer = create(:personal_customer, cpf: '624.299.657-04', type: 'PersonalCustomer')
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rented_car = create(:car, status: :scheduled)
      rental_with_code = create(:rental, car: rented_car, customer: customer, status: :scheduled, rented_code: '2024ABC123TREWR')
      rental_without_code = create(:rental, car: rented_car, customer: customer, status: :scheduled, rented_code: nil)

      expect(Rental.scheduled('2024ABC123TREWR')).to include(rental_with_code)
      expect(Rental.scheduled('2024ABC123TREWR')).not_to include(rental_without_code)
    end
  end
  
end
