require 'rails_helper'

RSpec.describe RentalPresenter do
include Rails.application.routes.url_helpers

  describe '#status' do
    it "should return a green badge for scheduled" do
      car = create(:car)
      personal_customer = create(:personal_customer)
      rental = build(:rental, customer: personal_customer, car: car, status: :scheduled)

      result = RentalPresenter.new(rental).status

      expect(result).to match /span/
      expect(result).to match /badge-success/
      expect(result).to match /Agendada/
    end

    it "should return a blue badge for active" do
      car = create(:car)
      personal_customer = create(:personal_customer)
      rental = build(:rental, customer: personal_customer, car: car, status: :active)

      result = RentalPresenter.new(rental).status

      expect(result).to match /span/
      expect(result).to match /badge-primary/
      expect(result).to match /em Andamento/
    end
  end

  describe "#withdraw_link" do
    it "should render a link to withdraw_rental_path" do
      car = create(:car)
      personal_customer = create(:personal_customer)
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rental = create(:rental, customer: personal_customer, car: car, status: :scheduled)

      result = RentalPresenter.new(rental).withdraw_link

      expect(result).to match /a/
      expect(result).to match /Confirmar Retirada/
      expect(result).to include withdraw_rental_path(rental.id)
    end

    it "should not render a link for active" do
      
      car = create(:car)
      personal_customer = create(:personal_customer)
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rental = create(:rental, customer: personal_customer, car: car, status: :active)

      result = RentalPresenter.new(rental).withdraw_link

      expect(result).to_not include withdraw_rental_path(rental.id)
      expect(result).to eq '' 
    end
  end

end
