require 'rails_helper'

feature 'Admin register inspection' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    palio = create(:car_model, name: 'Palio')
    create(:car, car_model: palio, license_plate: 'XLG-1234',
                subsidiary: user.subsidiary)

    login_as user
    visit root_path
    fill_in 'search-field', with: 'XLG-1234'
    click_on 'Buscar'
    click_on 'Enviar para vistoria'
    select '1/4', from: 'Nível de combustível'
    select 'Limpo', from: 'Limpeza'
    fill_in 'Avarias', with: 'Veio pneu furado'
    click_on 'Vistoriado'

    expect(page).to have_link('Enviar para vistoria')
    expect(page).to have_content('Status: Disponível')
  end

  scenario 'unsuccessfully - missing fields' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    palio = create(:car_model, name: 'Palio')
    car = create(:car, car_model: palio, license_plate: 'XLG-1234',
                subsidiary: user.subsidiary)

    login_as user
    visit root_path
    fill_in 'search-field', with: 'XLG-1234'
    click_on 'Buscar'
    click_on 'Enviar para vistoria'
    # Não preenche nenhum campo obrigatório
    click_on 'Vistoriado'

    expect(page).to have_content('Você deve preencher todos os campos')
    expect(page).to have_content('Nível de combustível')
    expect(page).to have_content('Nível de Limpeza')
    expect(page).to have_content('Avarias')
    expect(page).to have_button('Vistoriado')
    
  end
end
