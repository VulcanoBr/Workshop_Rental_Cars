require 'rails_helper'

feature 'User canceled rental' do
  
  
  
  it 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacture = create(:manufacture)
    car_model = create(:car_model, manufacture: manufacture) 
    subsidiary_car_model = create(:subsidiary_car_model, price: 234.56, subsidiary_id: subsidiary.id, car_model_id: car_model.id)
    car= create(:car, car_model_id: car_model.id, subsidiary: user.subsidiary, status: :available)
    
    customer = create(:personal_customer, type: "PersonalCustomer") 
    allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
    rentals = create(:scheduled_rental, car_id: car.id, user_id: user.id, 
                customer_id: customer.id, daily_price: 234.56, status: :scheduled) 
  
    login_as user
    visit root_path
    click_on 'Agendar Locação'

    select car.car_identification, from: 'car-select'
    select customer.description.first, from: 'customer-select'
    fill_in 'Retirada Prevista', with: "#{Date.today}"
    fill_in 'Devolução Prevista', with: "#{Date.today + 5}"
    
    click_on 'Enviar'
    
    visit rental_path(rentals)
    
    expect(page).to have_link('Cancelar Locação')
  
    click_link('Cancelar Locação')

    expect(rentals.reload.canceled?).to be true
    expect(rentals.car.status).to eq('available')
    expect(page).to have_content("Um email de cancelamento foi enviado para o cliente")
    expect(page).to have_content('Locação cancelada com sucesso !!!')
    expect(page).to have_current_path(root_path)
  end
end
