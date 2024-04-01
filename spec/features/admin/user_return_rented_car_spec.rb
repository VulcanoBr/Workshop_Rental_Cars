require 'rails_helper'

feature 'User return car rental' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacture = create(:manufacture)
    car_model = create(:car_model, name: 'Palio', manufacture: manufacture, category: 'Standard')
    car = create(:car, car_model: car_model, license_plate: 'XLG-1234',
                      subsidiary: subsidiary, car_km: '100', status: :rented)
    car2 = create(:car, car_model: car_model, license_plate: 'XXX-1234',
                      subsidiary: subsidiary, car_km: '300', status: :rented)
    customer = create(:personal_customer, email: 'lucas@gmail.com')
    customer2 = create(:personal_customer, email: 'marcos@gmail.com', cpf: '624.299.657-04')
    allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
    rental = create(:rental, car: car, customer: customer, user: user, rented_code: '2024TYR56RTUYIU', status: :active)
    rental2 = create(:rental, car: car2, customer: customer2, user: user, rented_code: '2024TYR56RTUZZZ', status: :active)
    expect(RentalMailer).to receive(:send_return_receipt).with(rental.id)
                                                        .and_call_original

    login_as user
    visit root_path
    click_on 'Listar'
    click_on 'Carro(s) Alocado(s)'
    expect(page).to have_content('Carro(s) Alocado(s)')
    expect(page).to have_content('2024TYR56RTUZZZ')
    click_on('2024TYR56RTUYIU', match: :first)
    click_on 'Confirmar Devolução'

    fill_in 'Quilometragem', with: '199'
    click_on 'Devolver carro'

    expect(page).to have_content('Carro devolvido com sucesso')
    expect(page).to have_content('Status: Disponível ')
    expect(page).to have_content('Quilometragem: 199')
  end

  scenario 'ensure superior km actually' do
    user = create(:user)
    car_model = create(:car_model, name: 'Palio', category: 'Standard')
    car = create(:car, car_model: car_model, license_plate: 'XLG-1234',
                      subsidiary: user.subsidiary, car_km: 230, status: :rented)
    customer = create(:personal_customer)
    allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
    rental = create(:rental, car: car, user: user, customer: customer, rented_code: '2024TYR56RTUZZZ', status: :active)

    login_as user
    visit root_path
    click_on 'Listar'
    click_on 'Carro(s) Alocado(s)'
    click_on('2024TYR56RTUZZZ', match: :first)
    click_on 'Confirmar Devolução'

    fill_in 'Quilometragem', with: '199'
    click_on 'Devolver carro'

    expect(page).to have_content('Quilometragem não pode ser menor que a atual')
  end
end
