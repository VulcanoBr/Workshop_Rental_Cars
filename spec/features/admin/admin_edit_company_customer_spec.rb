require 'rails_helper'

feature 'Admin edit company customer' do
  scenario 'successfully updates' do
    user = create(:user)
    company_customer = create(:company_customer)

    login_as user, scope: :user
    visit edit_company_customer_path(company_customer)

    fill_in 'Nome', with: 'Vulcan Ltda (Atualizado)'
    fill_in 'Email', with: 'vulcan_atualizado@exemplo.com'

    click_on 'Salvar cliente'

    expect(page).to have_content('Vulcan Ltda (Atualizado)')
    expect(page).to have_content('vulcan_atualizado@exemplo.com')
    expect(page).to have_content('Cliente editado com sucesso')
  end

  scenario 'unsuccessfully updates' do
    user = create(:user)
    company_customer = create(:company_customer)

    login_as user, scope: :user
    visit edit_company_customer_path(company_customer)
    
    fill_in 'Nome', with: ''
    fill_in 'Email', with: ''
    
    click_on 'Salvar cliente'

    expect(page).to have_content('Você deve preencher todos os campos')
  end
end