require 'rails_helper'

RSpec.describe CarPresenter do
  include Rails.application.routes.url_helpers
  let(:user) { FactoryBot.create(:user, email: 'vulcan@rental.com', role: :admin) }
  let(:car) { FactoryBot.create(:car) }
  
  describe '#maintenance_link' do
    context 'when user is an admin and car is available' do
      let(:presenter) { CarPresenter.new(car, user) }

      it 'returns the link to create a new maintenance for the car' do
        expect(presenter.maintenance_link).to eq(new_car_maintenance_path(car.id))
      end
    end

    context 'when user is an admin, car is not available, and current maintenance is present' do
      let(:presenter) { CarPresenter.new(car, user) }

      it 'returns the link to return the maintenance for the car' do

        allow(car).to receive(:available?).and_return(false)
        allow(car).to receive(:current_maintenance).and_return(FactoryBot.create(:maintenance))

        expect(presenter.maintenance_link).to eq(new_return_maintenance_path(car.current_maintenance))
      end
    end

    context 'employee' do
      it 'should not render start maintenance link' do
        subs = create(:subsidiary)
        user = create(:user, subsidiary: subs)
        car = create(:car, subsidiary: subs, status: :available)

        result = CarPresenter.new(car, user).maintenance_link

        expect(result).to_not include new_car_maintenance_path(car.id)
        expect(result).to eq ''
      end
    end
  end
end
