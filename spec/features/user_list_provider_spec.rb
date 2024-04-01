require 'rails_helper'

feature 'View' do
  describe 'list' do
    
    let!(:subsidiary) { create(:subsidiary) }
    let!(:user) { create(:user, subsidiary: subsidiary) }
    let!(:provider) { create(:provider, name: 'Auto Car', cnpj: '19.531.702/0001-20', email: 'autocar@email.com') }
    let!(:providers) { create(:provider, name: 'Auto X', cnpj: '39.352.138/0001-95', email: 'autox@email.com') }

    it ' @providers all' do
      
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Fornecedor(es)'

      expect(current_path).to eq providers_path
      expect(page).to have_content('Lista de Fornecedor(es)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content(provider.name)
      expect(page).to have_content(providers.name)
    end

    it ' @providers not found name' do
      
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Fornecedor(es)'

      expect(current_path).to eq providers_path
      expect(page).to have_content('Lista de Fornecedor(es)')
      
      within('div.d-flex.justify-content-between.mt-3') do
        expect(page).to have_content("Lista de Fornecedor(es)")

        fill_in 'name', with: 'Nome do Fornecedor' # Substitua 'Nome do Providerro' pelo valor que você deseja preencher no campo de busca
        click_button 'Buscar'
      end
      allow(Provider).to receive(:search_by_name).with("Nome do Fornecedor").and_return([])
      expect(current_path).to eq providers_path
      expect(page).to have_content('Lista de Fornecedor(es)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content("Nenhum fornecedor encontrado para 'Nome do Fornecedor' !!!.")
    end

    it ' @providers found name' do
    
      login_as user
      visit root_path
      click_on 'Listar'
      click_on 'Fornecedor(es)'

      expect(current_path).to eq providers_path
    
      within('div.d-flex.justify-content-between.mt-3') do
        expect(page).to have_content("Lista de Fornecedor(es)")

        fill_in 'name', with: 'Auto X' # Substitua 'Nome do Providerro' pelo valor que você deseja preencher no campo de busca
        click_button 'Buscar'
      end
      allow(Provider).to receive(:search_by_name).with("Auto X").and_return(providers)
      expect(current_path).to eq providers_path
      expect(page).to have_content('Lista de Fornecedor(es)')
      expect(page).to have_button('Buscar')
      expect(page).to have_content(providers.name)
    end
  end
end

