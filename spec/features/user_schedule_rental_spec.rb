require 'rails_helper'

feature 'User schedule rental' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacture = create(:manufacture)
    car_model = create(:car_model, name: 'Suzuky Vitara', manufacture: manufacture, category: 'Standard')
    car = create(:car, car_model_id: car_model.id, subsidiary_id: user.subsidiary.id)
    
    customer = create(:personal_customer, name: 'Maria jose', email: 'maria@email.com', cpf: '024.714.660-95', phone: '(21)98897-5656', type: 'PersonalCustomer')
    subsidiary_car_model = create(:subsidiary_car_model, price: 234.56, subsidiary_id: subsidiary.id, car_model_id: car_model.id)
    allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
    create(:rental, car: car, user: user, customer: customer, daily_price: 234.56, status: :scheduled)

    login_as user
    visit root_path
    click_on 'Agendar Locação'
    select car.car_identification, from: 'car-select'
    select customer.description.first, from: 'customer-select'
    fill_in 'Retirada Prevista', with: "#{Date.today}"
    fill_in 'Devolução Prevista', with: "#{Date.today + 5}"
    click_on 'Enviar'

    expect(page).to have_content(car.car_identification)
    expect(page).to have_content(customer.description.first)
    expect(page).to have_content(user.email)
    expect(page).to have_content('Status: Agendada')
    expect(page).to have_content("Retirada Prevista: #{(Date.today).strftime("%d/%m/%Y")}")
    expect(page).to have_content("Devolução Prevista: #{(Date.today + 5).strftime("%d/%m/%Y")}")
  end

  scenario 'only from current subsidiary' do
    sub_paulista = create(:subsidiary, name: 'Paulista')
    sub_sao_miguel = create(:subsidiary, name: 'São Miguel')
    user_paulista = create(:user, subsidiary: sub_paulista)
    create(:user, subsidiary: sub_sao_miguel)
    manufacture = create(:manufacture)
    palio = create(:car_model, name: 'Palio', manufacture: manufacture, category: 'Standard')
    onix = create(:car_model, name: 'Ônix', manufacture: manufacture, category: 'Standard')
    car_paulista = create(:car, car_model: palio, license_plate: 'ABC-1234',
                                color: 'Azul', subsidiary: sub_paulista)
    car_sao_miguel = create(:car, car_model: onix, license_plate: 'CXZ-0987',
                                  color: 'Verde', subsidiary: sub_sao_miguel)
    create(:personal_customer)

    login_as user_paulista
    visit root_path
    click_on 'Agendar Locação'

    expect(page).to_not have_content(car_sao_miguel.car_identification)
    expect(page).to have_content(car_paulista.car_identification)
  end

  scenario 'customer cannot rent twice' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacture = create(:manufacture)
    car_model = create(:car_model, name: 'Maverick', manufacture: manufacture, category: 'Standard')
    subsidiary_car_model = create(:subsidiary_car_model, price: 234.56, subsidiary_id: subsidiary.id, car_model_id: car_model.id)
    car = create(:car, car_model_id: car_model.id, subsidiary_id: subsidiary.id)
    
    customer = create(:personal_customer, name: 'Henrique', cpf: '024.714.660-95', type: 'PersonalCustomer')
    rental1 = create(:rental, car: car, user: user, customer: customer, daily_price: 234.56, status: :scheduled)
    build(:rental, car: car, user: user, customer: customer, daily_price: 234.56, status: :scheduled)

    login_as user
    visit root_path
    click_on 'Agendar Locação'

    select car.car_identification, from: 'car-select'
    select customer.description.first, from: 'customer-select'
    fill_in 'Retirada Prevista', with: Date.today
    fill_in 'Devolução Prevista', with: Date.today + 5
    click_on 'Enviar'

    expect(page).to have_content('Cliente possui locação em aberto')
  end

  scenario 'company can rent twice' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacture = create(:manufacture)
    car_model = create(:car_model, name: 'Mustang', manufacture: manufacture, category: 'Standard')
    car_model2 = create(:car_model, name: 'Maverick', manufacture: manufacture)
    subsidiary_car_model = create(:subsidiary_car_model, price: 234.56, subsidiary_id: subsidiary.id, car_model_id: car_model.id)
    subsidiary_car_model2 = create(:subsidiary_car_model, price: 234.56, subsidiary_id: subsidiary.id, car_model_id: car_model2.id)
    car = create(:car, car_model_id: car_model.id, subsidiary_id: subsidiary.id, status: :available)
    car2 = create(:car, car_model_id: car_model2.id, subsidiary_id: subsidiary.id, status: :available)
    customer = create(:company_customer, name: 'Acme INC', cnpj: '18.187.641/0001-62', type: 'CompanyCustomer')
    rental1 = create(:rental, car: car, user: user, customer_id: customer.id, daily_price: 234.56, status: :scheduled)
    rental = create(:rental, car: car2, user: user, customer_id: customer.id, daily_price: 234.56, status: :scheduled)
    
    login_as user
    visit root_path
    click_on 'Agendar Locação'

    select car.car_identification, from: 'car-select'
    select customer.description, from: 'customer-select'
    fill_in 'Retirada Prevista', with: "#{Date.today}"
    fill_in 'Devolução Prevista', with: "#{Date.today + 5}"
    click_on 'Enviar'

    expect(page).to have_content('Um email de confirmação foi enviado para o cliente')
    expect(page).to have_content(car.car_identification)
    expect(page).to have_content(customer.description)
    expect(page).to have_content(user.email)
  end
end
