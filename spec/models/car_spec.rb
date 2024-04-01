require 'rails_helper'

RSpec.describe Car, type: :model do
  it "validates presence of car_model, car_km, color, and license_plate" do
    car = build(:car, car_model: nil, car_km: nil, color: nil, license_plate: nil)
    expect(car).not_to be_valid
    expect(car.errors.full_messages).to include(
      "Modelo é obrigatório(a)", "Modelo não pode ficar em branco",
      "Quilometragem não pode ficar em branco",
      "Cor não pode ficar em branco",
      "Placa não pode ficar em branco"
    )
  end

  it 'validates presence of car_model' do
    car = build(:car, car_model: nil)
    expect(car).not_to be_valid
    expect(car.errors[:car_model][0]).to include("é obrigatório(a)")
    expect(car.errors[:car_model][1]).to include("não pode ficar em branco")
  end

  it 'validates presence of car_km' do
    car = build(:car, car_km: nil)
    expect(car).not_to be_valid
    expect(car.errors[:car_km]).to include("não pode ficar em branco")
  end

  it 'validates presence of color' do
    car = build(:car, color: nil)
    expect(car).not_to be_valid
    expect(car.errors[:color]).to include("não pode ficar em branco")
  end

  it 'validates presence of license_plate' do
    car = build(:car, license_plate: nil)
    expect(car).not_to be_valid
    expect(car.errors[:license_plate]).to include("não pode ficar em branco")
  end

  it "validates that car_km cannot be less than the actual km on update" do
    car = create(:car, car_km: 10000)
    car.car_km = 5000
    expect(car).not_to be_valid
    expect(car.errors[:car_km]).to include("Quilometragem não pode ser menor que a atual")
  end

  it "returns the car identification string" do
    car_model = create(:car_model, name: "Model X")
    car = create(:car, car_model: car_model)
    expect(car.car_identification).to eq("Model X - #{car.license_plate} - #{car.car_model.category}")
  end

  it "returns the last maintenance if the car is on maintenance" do
    provider=  create(:provider, name: 'Vulcan Ltfa', cnpj: '40.599.997/0001-62', email: 'vulcan@email.com') 
    car = create(:car, :on_maintenance)
    create(:maintenance, car: car, provider: provider)
    expect(car.current_maintenance).to be_a(Maintenance)
  end
  
  it "returns nil if the car is not on maintenance" do
    car = create(:car)
    expect(car.current_maintenance).to be_nil
  end

  describe ".with_available_status_and_price" do
    let!(:subsidiary) { create(:subsidiary) }
    let!(:manufacture) { create(:manufacture, name: 'Honda') }
    let!(:car_model) { create(:car_model, name: "Model X", manufacture_id: manufacture.id) }
    let!(:subsidiary_car_model) { create(:subsidiary_car_model, price: 123.45, subsidiary_id: subsidiary.id, car_model_id: car_model.id) }
    let!(:available_car) { create(:car, car_model: car_model, subsidiary: subsidiary, status: 'available' ) }
    let!(:unavailable_car) { create(:car, car_model: car_model, subsidiary: subsidiary, status: 'scheduled' ) }

    it "includes cars with available status" do
      expect(Car.with_available_status_and_price).to include(available_car)
    end

    it "excludes cars with unavailable status" do
      expect(Car.with_available_status_and_price).not_to include(unavailable_car)
    end

    it "orders cars by car model name" do
      car_model = create(:car_model, name: "Model X", manufacture_id: manufacture.id)
      car_model2 = create(:car_model, name: "Model M", manufacture_id: manufacture.id)
      subsidiary_car_model = create(:subsidiary_car_model, price: 123.45, subsidiary_id: subsidiary.id, car_model_id: car_model.id) 
      subsidiary_car_model2 = create(:subsidiary_car_model, price: 323.45, subsidiary_id: subsidiary.id, car_model_id: car_model2.id)
      car1 = create(:car, car_model_id: car_model.id, subsidiary_id: subsidiary.id, status: 'available')
      car2 = create(:car, car_model_id: car_model2.id, subsidiary_id: subsidiary.id, status: 'available')
      expect(Car.with_available_status_and_price.first).to eq(car2)
    end
  end
  
end
