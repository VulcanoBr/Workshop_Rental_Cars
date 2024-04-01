require 'rails_helper'

RSpec.describe Maintenance, type: :model do

  describe 'validations' do
    let!(:provider) { create(:provider, name: 'Vulcan Ltfa', cnpj: '18.187.641/0001-62', email: 'vulcan@email.com') }
    it 'validates presence of invoice on update' do
      maintenance = create(:maintenance, provider_id: provider.id)
      maintenance.invoice = nil
      expect(maintenance).not_to be_valid(:update)
      expect(maintenance.errors[:invoice]).to include("não pode ficar em branco")
    end

    it 'validates presence of service_cost on update' do
      maintenance = create(:maintenance, provider_id: provider.id)
      maintenance.service_cost = nil
      expect(maintenance).not_to be_valid(:update)
      expect(maintenance.errors[:service_cost]).to include("não pode ficar em branco")
    end

    it 'validates presence of provider_id on create' do
      maintenance = build(:maintenance, provider_id: nil)
      expect(maintenance).not_to be_valid(:create)
      expect(maintenance.errors[:provider_id]).to include("não pode ficar em branco")
    end
  end

  describe '.cars_on_maintenance' do
    it 'returns maintenance records with cars on maintenance' do
      provider = create(:provider, name: 'Vulcan Ltfa', cnpj: '18.187.641/0001-62', email: 'vulcan@email.com')
      car = create(:car, status: :on_maintenance)
      maintenance = create(:maintenance, car_id: car.id, provider_id: provider.id)
      expect(Maintenance.cars_on_maintenance).to include(maintenance)
    end
  end

  describe '#car_return' do
    let(:car) { create(:car, status: :on_maintenance) }
    let(:provider) do
      Provider.create(name: 'Solucoes.ltda', cnpj: '18.187.641/0001-62', email: 'vulcan@email.com')
    end

    it 'should create a debit' do
      maintenance = create(:maintenance, car: car, provider: provider)
      maintenance.car_return(service_cost: 1000, invoice: 'GHASHASDB123J81NN')

      expect(maintenance).to be_valid
      expect(Debit.last.amount).to eq maintenance.service_cost
    end

    it 'should set the car status to available' do
      maintenance = create(:maintenance, car: car, provider: provider)
      maintenance.car_return(service_cost: 1000, invoice: 'GHASHASDB123J81NN')

      expect(car.status).to eq 'available'
    end

    it 'returns false if update fails' do
      maintenance = create(:maintenance, car: car, provider: provider)
      params = [invoice: nil, service_cost: nil]
      allow(maintenance).to receive(:update).and_return(false)
      expect(maintenance.car_return(params)).to be false
    end
  end
end
