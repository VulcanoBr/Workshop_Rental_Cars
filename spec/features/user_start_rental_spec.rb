require 'rails_helper'

feature 'User start rental' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary_id: subsidiary.id)
    manufacture = create(:manufacture)
    car_model = create(:car_model, manufacture: manufacture, category: 'Standard')
    subsidiary_car_model = create(:subsidiary_car_model, price: 234.56, subsidiary_id: subsidiary.id, car_model_id: car_model.id)
    car = create(:car, car_model_id: car_model.id, subsidiary_id: subsidiary.id)
    customer = create(:personal_customer)
    allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
    rental = create(:scheduled_rental, car: car, customer: customer, daily_price: 234.56, status: :scheduled)
    @rental = rental

    login_as user
    visit root_path
    click_on 'Agendar Locação'

    select car.car_identification.to_s, from: 'car-select'
    select customer.description.first, from: 'customer-select'
    fill_in 'Retirada Prevista', with: "#{Date.today}"
    fill_in 'Devolução Prevista', with: "#{Date.today + 5}"

    click_on 'Enviar'
    visit rental_path(rental)
    
    
    expect(page).to have_content(car.car_identification)
    expect(page).to have_content(customer.description.first)
    expect(page).to have_link('Confirmar Retirada')
  
    click_link('Confirmar Retirada')

    expect(rental.reload.active?).to be true

    expect(page).to have_current_path(rental_path(rental))
    expect(page).to have_content('Data de Retirada:')
    expect(page).to have_content('Status: em Andamento')
    expect(page).to have_link('Confirmar Devolução')
    expect(current_path).to eq rental_path(rental.id)
  end
end
