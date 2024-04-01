require 'rails_helper'

feature 'Admin register customer ' do
  scenario 'successfully for company customer' do
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Cliente'
    click_on 'Novo cliente'
    click_on 'Pessoa Jurídica'
    fill_in 'Nome', with: 'Vulcan Ltda'
    fill_in 'Nome Fantasia', with: 'Vulcan Informatica'
    fill_in 'Email', with: 'vulcan@exemplo.com'
    fill_in 'CNPJ', with: '73.417.358/0001-98'
    fill_in 'Telefone', with: '12345678'
    click_on 'Salvar cliente'

    expect(page).to have_content('Vulcan Ltda')
    expect(page).to have_content('Vulcan Informatica')
    expect(page).to have_content('vulcan@exemplo.com')
    expect(page).to have_content('73.417.358/0001-98')
    expect(page).to have_content('12345678')
    expect(page).to have_content('Cliente cadastrado com sucesso')
  end

  scenario 'validate company customer data' do
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Cliente'
    click_on 'Novo cliente'
    click_on 'Pessoa Jurídica'
    fill_in 'Nome', with: ''
    fill_in 'Email', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Salvar cliente'

    expect(page).to have_content('Você deve preencher todos os campos')
  end
end
