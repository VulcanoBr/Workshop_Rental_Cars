require 'rails_helper'

RSpec.describe ReturnCarJob do 
  describe '.auto_enqueue' do
    it 'should queue successfully for personal customers' do
      car = create(:car)
      personal_customer = create(:personal_customer)
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rental = create(:rental, car: car, customer: personal_customer, started_at: Time.zone.now)
  
      described_class.auto_queue(rental.id)
    
      expect(Delayed::Worker.new.work_off).to eq([1,0])
    end
  
    it 'should queue successfully for company customers' do
      car = create(:car)
      company_customer = create(:company_customer, cnpj: '18.187.641/0001-62')
      allow_any_instance_of(Rental).to receive(:customer_has_active_rental).and_return(nil)
      rental = create(:rental, car: car, customer: company_customer, started_at: Time.zone.now)
    
      described_class.auto_queue(rental.id)
    
      expect(Delayed::Worker.new.work_off).to eq([1,0])
    end
  end
end