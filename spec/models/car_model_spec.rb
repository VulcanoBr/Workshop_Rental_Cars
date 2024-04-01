require 'rails_helper'

RSpec.describe CarModel, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      car_model = build(:car_model, name: nil)
      expect(car_model).not_to be_valid
      expect(car_model.errors[:name]).to include("não pode ficar em branco")
    end

    it 'validates presence of year' do
      car_model = build(:car_model, year: '')
      expect(car_model).not_to be_valid
      expect(car_model.errors[:year]).to include("não pode ficar em branco")
      expect(car_model.errors[:year]).to include("é muito curto (mínimo: 4 caracteres)")
      expect(car_model.errors[:year]).to include("não é válido")
    end

    it 'validates presence of car_options' do
      car_model = build(:car_model, car_options: nil)
      expect(car_model).not_to be_valid
      expect(car_model.errors[:car_options]).to include("não pode ficar em branco")
    end

    it 'validates presence of manufacture_id' do
      car_model = build(:car_model, manufacture: nil)
      expect(car_model).not_to be_valid
      expect(car_model.errors[:manufacture]).to include("é obrigatório(a)")
    end

    # Test numericality and length validations for year
    it 'validates that year is an integer with a length < 4' do
      car_model = build(:car_model, year: 'dsd')
      expect(car_model).not_to be_valid
      expect(car_model.errors[:year]).to include("não é válido")
      expect(car_model.errors[:year]).to include("é muito curto (mínimo: 4 caracteres)")
    end

    it 'validates that year is an integer with a length = 4' do
      car_model = build(:car_model, year: 'dsdd')
      expect(car_model).not_to be_valid
      expect(car_model.errors[:year]).to include("não é válido")

    end

    it 'validates that year is an integer with a length > 4 and < 9' do
      car_model = build(:car_model, year: '3435/99')
      expect(car_model).not_to be_valid
      expect(car_model.errors[:year]).to include("não é válido")
    end

    it 'validates that year is an integer with a length > 9' do
      car_model = build(:car_model, year: 'dsdd/xxxx4')
      expect(car_model).not_to be_valid
      expect(car_model.errors[:year]).to include("não é válido")
      expect(car_model.errors[:year]).to include("é muito longo (máximo: 9 caracteres)")
    end

    it 'validates that year is an integer with a length = 9 and format not = 9999/9999' do
      car_model = build(:car_model, year: 'dsdd/xxxx')
      expect(car_model).not_to be_valid
      expect(car_model.errors[:year]).to include("não é válido")
    end
  end
end
