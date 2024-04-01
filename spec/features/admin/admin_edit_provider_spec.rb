require 'rails_helper'

feature 'Admin edit provider' do
  scenario 'successfully' do
    user = create(:user)
    create(:provider, name: 'Fabiana', cnpj: '19.531.702/0001-20', email: 'fabi@email.com')

    login_as user, scope: :user
    visit root_path
    click_on 'Listar'
    click_on 'Fornecedor(es)'
    click_on 'Fabiana'
    click_on 'Editar fornecedor'
    fill_in 'Nome', with: 'Juliana'
    fill_in 'Email', with: 'ju@exemplo.com'
    fill_in 'CNPJ', with: '19.531.702/0001-20'
    fill_in 'Telefone', with: '234342223'
    click_on 'Cadastrar fornecedor'

    expect(page).to have_content('Juliana')
    expect(page).to have_content('ju@exemplo.com')
    expect(page).to have_content('19.531.702/0001-20')
    expect(page).to have_content('234342223')
    expect(page).to have_content('Fornecedor editado com sucesso')
  end

  scenario 'unsuccessfully' do
    user = create(:user)
    create(:provider, name: 'Juliana', cnpj: '19.531.702/0001-20')

    login_as user, scope: :user
    visit root_path
    click_on 'Listar'
    click_on 'Fornecedor(es)'
    click_on 'Juliana'
    click_on 'Editar fornecedor'
    fill_in 'Nome', with: ''
    fill_in 'Email', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Cadastrar fornecedor'

    expect(page).to have_content('Você deve preencher todos os campos')
  end
end
