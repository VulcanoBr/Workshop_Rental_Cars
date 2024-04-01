# spec/models/fine_spec.rb
require 'rails_helper'

RSpec.describe Fine, type: :model do
  describe 'validations' do
    it 'should require issued_on, demerit_points, fine_value, and address' do
      fine = build(:fine, issued_on: nil, demerit_points: nil, fine_value: nil, address: nil)
      expect(fine).not_to be_valid
      expect(fine.errors[:issued_on]).to include("não pode ficar em branco")
      expect(fine.errors[:demerit_points]).to include("não pode ficar em branco")
      expect(fine.errors[:fine_value]).to include("não pode ficar em branco")
      expect(fine.errors[:address]).to include("não pode ficar em branco")
    end
  end

  describe "calculate_fines_cost_by_year" do
    it "returns fines cost by year" do
      manufacture = create(:manufacture)
      subsidiary = create(:subsidiary)
      car_model = create(:car_model, manufacture_id: manufacture.id)
      car = create(:car, car_model_id: car_model.id, subsidiary_id: subsidiary.id)
      fine_1 = create(:fine, car_id: car.id, issued_on: "2023-01-01", fine_value: 100)
      fine_2 = create(:fine, car_id: car.id, issued_on: "2023-02-01", fine_value: 150)
      fine_3 = create(:fine, car_id: car.id, issued_on: "2024-01-01", fine_value: 200)
      
      result = Fine.calculate_fines_cost_by_year(2023)
      expected_result = [
        {
          id: subsidiary.id,
          total_fine_cost: 250,
          fines_count: 1
        }]
      expect(result.length).to eq(1)
      expect(result.first.total_fine_cost).to eq(250) # 100 + 150
      expect(result.first.fines_count).to eq(2)
    end
  end
end
