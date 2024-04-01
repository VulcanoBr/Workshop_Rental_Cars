require 'rails_helper'

RSpec.describe 'Home', type: :feature do
  let(:user) { create(:user) } # Lembre-se de criar uma Factory para o modelo User se necessário

  before do
    login_as(user, scope: :user)
    visit root_path
  end

  it 'exibe mensagem correta para nenhum carro encontrado' do
    fill_in 'Buscar carro...', with: 'CarroInexistente'
    click_button 'Buscar'

    expect(page).to have_content('Nenhum carro encontrado')
  end
end
