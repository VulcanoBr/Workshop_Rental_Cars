require 'rails_helper'

RSpec.describe RentalHelper do
  
  context "#status" do
    it "should return a green badge for scheduled" do
      car = create(:car)
      personal_customer = create(:personal_customer)
      rental = build(:rental, customer: personal_customer, car: car, status: :scheduled)

      result = status(rental)

      expect(result).to match /span/
      expect(result).to match /badge-success/
      expect(result).to match /Agendada/

    end
    
    it "should return a blue badge for active" do
      car = create(:car)
      personal_customer = create(:personal_customer)
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rental = create(:rental, customer: personal_customer, car: car, status: :active)

      result = status(rental)

      expect(result).to match /span/
      expect(result).to match /badge-primary/
      expect(result).to match /em Andamento/

    end
  end
end