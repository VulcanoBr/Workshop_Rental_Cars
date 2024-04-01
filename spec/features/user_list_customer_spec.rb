require 'rails_helper'

feature 'View' do
  describe 'list' do
    
    let!(:subsidiary) { create(:subsidiary) }
    let!(:user) { create(:user, subsidiary: subsidiary) }
    let!(:customer) { create(:customer, name: 'Samurai Americano', cpf: '204.193.250-34', email: 'samu@email.com', type: 'PersonalCustomer') }
    let!(:customers) { create(:customer, name: 'Rapina Ativa', cnpj: '39.352.138/0001-95', email: 'rapina@email.com', type: 'CompanyCustomer') }

    it ' @customers all' do
      
      login_as user
      visit root_path
      click_on 'Cliente'
      click_on 'Ver Cliente(s)'

      expect(current_path).to eq customers_path
      expect(page).to have_content('Lista de Cliente(s)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content(customer.name)
      expect(page).to have_content(customers.name)
    end

    it ' @customers not found name' do
      
      login_as user
      visit root_path
      click_on 'Cliente'
      click_on 'Ver Cliente(s)'

      expect(current_path).to eq customers_path
      expect(page).to have_content('Lista de Cliente(s)')
      
      within('div.d-flex.justify-content-between.mt-3') do
        expect(page).to have_content("Lista de Cliente(s)")

        fill_in 'name', with: 'Nome do Cliente' # Substitua 'Nome do customerro' pelo valor que você deseja preencher no campo de busca
        click_button 'Buscar'
      end
      allow(Customer).to receive(:search_by_name).with("Nome do Cliente").and_return([])
      expect(current_path).to eq customers_path
      expect(page).to have_content('Lista de Cliente(s)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content("Nenhum cliente encontrado para 'Nome do Cliente' !!!.")
    end

    it ' @customers found name' do
    
      login_as user
      visit root_path
      click_on 'Cliente'
      click_on 'Ver Cliente(s)'

      expect(current_path).to eq customers_path
    
      within('div.d-flex.justify-content-between.mt-3') do
        expect(page).to have_content("Lista de Cliente(s)")

        fill_in 'name', with: 'Rapina' # Substitua 'Nome do customerro' pelo valor que você deseja preencher no campo de busca
        click_button 'Buscar'
      end
      allow(Customer).to receive(:search_by_name).with("Rapina").and_return(customers)
      expect(current_path).to eq customers_path
      expect(page).to have_content('Lista de Cliente(s)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content(customers.name)
    end
  end
end

