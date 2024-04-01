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
    let!(:car) { create(:car, car_model_id: car_model.id, subsidiary_id: subsidiary.id, status: 'available') }
    let!(:car2) { create(:car, car_model_id: car_model2.id, subsidiary_id: subsidiary.id, status: 'available') }

    it ' @available_cars all' do
      
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Carros Disponiveis'

      expect(current_path).to eq available_cars_cars_path
      expect(page).to have_content('Carros Disponiveis')
      expect(page).to have_button('Buscar')
      expect(page).to have_content(car.car_identification)
    end

    it ' @available_cars not found name' do
      
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Carros Disponiveis'

      expect(current_path).to eq available_cars_cars_path
      expect(page).to have_content('Carro(s) Disponiveis')
      
      within('div.d-flex.justify-content-between.mt-3.sticky-top') do
        expect(page).to have_content("Carro(s) Disponiveis")

        fill_in 'name', with: 'Nome do Carro' # Substitua 'Nome do Carro' pelo valor que você deseja preencher no campo de busca
        click_button 'Buscar'
      end
      allow(Car).to receive(:with_available_status_and_price).with("Carro").and_return([])
      expect(current_path).to eq available_cars_cars_path
      expect(page).to have_content('Carro(s) Disponiveis')
      expect(page).to have_button('Buscar')
      expect(page).to have_content('Descrição')
      expect(page).to have_content("Nenhum carro encontrado para 'Nome do Carro' !!!.")
    end

    it ' @available_cars found name' do
    
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Carros Disponiveis'

      expect(current_path).to eq available_cars_cars_path
    
      within('div.d-flex.justify-content-between.mt-3.sticky-top') do
        expect(page).to have_content("Carro(s) Disponiveis")

        fill_in 'name', with: 'Model M' # Substitua 'Nome do Carro' pelo valor que você deseja preencher no campo de busca
        click_button 'Buscar'
      end
      allow(Car).to receive(:with_available_status_and_price).with("Model").and_return(car2)
      expect(current_path).to eq available_cars_cars_path
      expect(page).to have_content('Carro(s) Disponiveis')
      expect(page).to have_button('Buscar')
      expect(page).to have_content('Descrição')
      expect(page).to have_content(car2.car_identification)
    end
  end
end

