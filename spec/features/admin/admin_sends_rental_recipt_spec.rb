require 'rails_helper'

feature 'Admin sends rental recipt through email' do
  it 'successfully' do
    sent_mail = class_spy(RentalMailer)
    stub_const('RentalMailer', sent_mail)
    mailer = double('RentalMailer')

    subsidiary = create(:subsidiary)
    user = create(:user)
    car_model = create(:car_model)
    subsidiary_car_model = create(:subsidiary_car_model, subsidiary_id: subsidiary.id, car_model_id: car_model.id)
    car = create(:car, car_model_id: car_model.id, subsidiary: user.subsidiary)
    customer = create(:personal_customer, name: 'João')
    allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
    rental = create(:rental, customer_id: customer.id, car_id: car.id, daily_price: 234.56, ended_at: Date.today)
    allow(RentalMailer).to receive(:send_rental_receipt).and_return(mailer)
    allow(mailer).to receive(:deliver_now)

    login_as user
    visit root_path
    click_on 'Agendar Locação'
    select car.car_identification.to_s, from: 'car-select'
    select "João", from: 'customer-select'
    fill_in 'Retirada Prevista', with: "#{Date.today}"
    fill_in 'Devolução Prevista', with: "#{Date.today + 5}" 
    click_on 'Enviar'

    expect(page).to have_content('Um email de confirmação foi enviado para o '\
    'cliente')
    expect(RentalMailer).to have_received(:send_rental_receipt)
      .with(Rental.last.id)
  end
end
