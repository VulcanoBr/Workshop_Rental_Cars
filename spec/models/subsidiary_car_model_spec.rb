require 'rails_helper'

RSpec.describe SubsidiaryCarModel, type: :model do
  # Test validations
  describe 'validations' do
    it 'validates presence of price' do
      subsidiary = create(:subsidiary)
      car_model = create(:car_model)
      subsidiary_car_model = build(:subsidiary_car_model, subsidiary_id: subsidiary.id, 
                              car_model_id: car_model.id, price: '')
      expect(subsidiary_car_model).not_to be_valid
      expect(subsidiary_car_model.errors[:price]).to include("não pode ficar em branco")
    end
   
    it 'validates presence of car_model' do
      subsidiary_car_model = build(:subsidiary_car_model, car_model: nil)
      expect(subsidiary_car_model).not_to be_valid
      expect(subsidiary_car_model.errors.full_messages).to include(
                "Modelo é obrigatório(a)", "Modelo não pode ficar em branco")
      expect(subsidiary_car_model.errors[:car_model][0]).to include("é obrigatório(a)")
      expect(subsidiary_car_model.errors[:car_model][1]).to include("não pode ficar em branco")
    end
  end
end
