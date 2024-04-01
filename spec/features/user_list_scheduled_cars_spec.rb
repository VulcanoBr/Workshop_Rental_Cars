require 'rails_helper'

feature 'View' do
  describe 'list' do
    
    let!(:subsidiary) { create(:subsidiary) }
    let!(:user) { create(:user, subsidiary: subsidiary) }
    let!(:manufacture) { create(:manufacture) }
    let!(:car_model) { create(:car_model, name: "Model X", manufacture_id: manufacture.id) }
    let!(:car_model2) { create(:car_model, name: "Model M", manufacture_id: manufacture.id) }
    let!(:subsidiary_car_model) { create(:subsidiary_car_model, price: 123.45, subsidiary_id: subsidiary.id, car_model_id: car_model.id) }
    let!(:subsidiary_car_model2) { create(:subsidiary_car_model, price: 323.45, subsidiary_id: subsidiary.id, car_model_id: car_model2.id) }
    let!(:car) { create(:car, car_model_id: car_model.id, subsidiary_id: subsidiary.id, status: 'scheduled') }
    let!(:car2) { create(:car, car_model_id: car_model2.id, subsidiary_id: subsidiary.id, status: 'scheduled') }
    let!(:customer) { create(:personal_customer, cpf: '822.220.210-30', type: 'PersonalCustomer') }
    let!(:customer2) { create(:personal_customer, cpf: '237.651.770-24', type: 'PersonalCustomer') }
    #allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
    let!(:rental) { create(:scheduled_rental, car_id: car.id, user_id: user.id, 
              customer_id: customer.id, rented_code: '2024TYR56RTUYIU', daily_price: 234.56, status: :scheduled) }
    let!(:rentals) { create(:scheduled_rental, car_id: car2.id, user_id: user.id, 
              customer_id: customer2.id, rented_code: '2024TYR56RTUBAD', daily_price: 334.56, status: :scheduled) }

    it ' @scheduled_rental all' do
      
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Carro(s) Agendado(s)'
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      expect(current_path).to eq scheduled_cars_rentals_path
      expect(page).to have_content('Carro(s) Agendado(s)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content(rental.rented_code)
    end

    it ' @scheduled_cars not found rented code' do
      
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Carro(s) Agendado(s)'

      expect(current_path).to eq scheduled_cars_rentals_path
      expect(page).to have_content('Carro(s) Agendado(s)')
      
      within('div.d-flex.justify-content-between.mt-3.sticky-top') do
        expect(page).to have_content("Carro(s) Agendado(s)")

        fill_in 'rented_code', with: '204RTREYY' # Substitua 'Nome do Carro' pelo valor que você deseja preencher no campo de busca
        click_button 'Buscar'
      end
      allow(Rental).to receive(:scheduled).with("204RTREYY").and_return([])
      expect(current_path).to eq scheduled_cars_rentals_path
      expect(page).to have_content('Carro(s) Agendado(s)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content('Codigo de Locação')
      expect(page).to have_content("Nenhuma locação encontrada para '204RTREYY' !!!.")
    end

    it ' @scheduled_cars found rented code' do
    
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Carro(s) Agendado(s)'

      expect(current_path).to eq scheduled_cars_rentals_path
    
      within('div.d-flex.justify-content-between.mt-3.sticky-top') do
        expect(page).to have_content("Carro(s) Agendado(s)")

        fill_in 'rented_code', with: '2024TYR56RTUBAD' # Substitua 'Nome do Carro' pelo valor que você deseja preencher no campo de busca
        click_button 'Buscar'
      end
      allow(Car).to receive(:scheduled).with("Model").and_return(rentals)
      expect(current_path).to eq scheduled_cars_rentals_path
      expect(page).to have_content('Carro(s) Agendado(s)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content('Codigo de Locação')
      expect(page).to have_content(rentals.rented_code)
    end
  end
end

