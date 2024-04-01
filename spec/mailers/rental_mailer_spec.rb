require 'rails_helper'

RSpec.describe RentalMailer, type: :mailer do
  describe '#send_rental_receipt' do
    it 'should send receipt' do
      user = create(:user)
      car = create(:car, subsidiary: user.subsidiary)
      customer = create(:personal_customer, name: 'Julio')
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rental = create(:finished_rental, car: car, user: user, customer: customer, 
                      scheduled_start: Date.today, scheduled_end: Date.today + 5)

      mail = RentalMailer.send_rental_receipt(rental.id)
      expect(mail.to).to include customer.email
      expect(mail.subject).to eq "Recibo de aluguel - #{rental.rented_code}"
      expect(mail.body).to include customer.name
      expect(mail.body).to include "Alugado em: #{rental.created_at.strftime("%d/%m/%Y %H:%M:%S")}"
      expect(mail.body).to include car.car_model.name
      
    end
  end
  describe '#send_return_receipt' do
    it 'should send receipt for returning a car' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      manufacture = create(:manufacture)
      car_model = create(:car_model, name: 'Palio', manufacture: manufacture)
      car = create(:car, car_model: car_model, license_plate: 'XLG-1234',
                        subsidiary: subsidiary, car_km: '100')
      customer = create(:personal_customer, name: 'Debora')
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rental = create(:rental, car: car, customer: customer, user: user)

      mail = RentalMailer.send_return_receipt(rental.id)
      expect(mail.to).to include customer.email
      expect(mail.subject).to eq 'Seu recibo de devolução'
      expect(mail.body).to include customer.name
      expect(mail.body).to include car.car_model.name
      expect(mail.body).to include "Data de devolução: #{rental.finished_at}"
    end
  end

  describe '#send_location_canceled' do
    
    it 'renders the headers and body' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      manufacture = create(:manufacture)
      car_model = create(:car_model, name: 'Palio', manufacture: manufacture)
      car = create(:car, car_model: car_model, license_plate: 'XLG-1234',
                        subsidiary: subsidiary, car_km: '100')
      customer = create(:personal_customer, name: 'Julio')
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rental = create(:rental, customer_id: customer.id, car_id: car.id, ended_at: Date.today)
      mail = described_class.send_location_canceled(rental.id) 
      expect(mail.subject).to eq("Recibo de cancelamento - #{rental.rented_code}")
      expect(mail.to).to eq([rental.customer.email])
      expect(mail.from).to eq(['from@example.com']) # Set your sender email address

      expect(mail.body.encoded).to match("Seu recibo de cancelamento")
      expect(mail.body.encoded).to match("Nome: #{rental.customer.name}")
      expect(mail.body.encoded).to match("<p>#{car.car_model.name} #{car.license_plate}</p>")
      expect(mail.body.encoded).to match("Data de cancelamento: #{rental.ended_at.strftime('%d/%m/%Y %H:%M:%S')}")
    end
  end
end
