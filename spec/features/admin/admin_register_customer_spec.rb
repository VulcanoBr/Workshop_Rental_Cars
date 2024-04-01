require 'rails_helper'

feature 'Admin register customer' do
  scenario 'successfully for personal customer' do
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Cliente'
    click_on 'Novo cliente'
    click_on 'Pessoa Física'
    fill_in 'Nome', with: 'Josy'
    fill_in 'Email', with: 'josy@exemplo.com'
    fill_in 'CPF', with: '765.632.190-04'
    fill_in 'Telefone', with: '12345678'
    click_on 'Salvar cliente'

    expect(page).to have_content('Josy')
    expect(page).to have_content('josy@exemplo.com')
    expect(page).to have_content('765.632.190-04')
    expect(page).to have_content('12345678')
    expect(page).to have_content('Cliente cadastrado com sucesso')
  end

  scenario 'validate personal customer data' do
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Cliente'
    click_on 'Novo cliente'
    click_on 'Pessoa Física'
    fill_in 'Nome', with: ''
    fill_in 'Email', with: ''
    fill_in 'CPF', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Salvar cliente'

    expect(page).to have_content('Você deve preencher todos os campos')
  end
end
