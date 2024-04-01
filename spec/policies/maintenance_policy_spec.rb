require 'rails_helper'

RSpec.describe MaintenancePolicy do
  describe "#authorized?" do

    context 'admin' do
      it 'should return true if admin' do
        sub = create(:subsidiary)
        user = build(:user, role: :admin, subsidiary: sub)
        car = build(:car, subsidiary: sub)

        result = described_class.new(car, user).authorized?
        expect(result).to eq true
      end
    end
    
    context 'manager' do
      it 'should return true if managar sub is the same car sub' do
        sub = create(:subsidiary)
        user = build(:user, role: :manager, subsidiary: sub)
        car = build(:car, subsidiary: sub)

        result = described_class.new(car, user).authorized?
        expect(result).to eq true
      end

      it 'should return false if manager sub diff from car sub' do
        sub_sp = create(:subsidiary, name: 'Matriz')
        sub_pa = create(:subsidiary, name: 'Pará')
        user = build(:user, role: :manager, subsidiary: sub_sp)
        car = build(:car, subsidiary: sub_pa)
        
        result = described_class.new(car, user).authorized?
        
        expect(result).to eq false
      end
    end

    context 'employee' do
      it 'should return false if employee' do
        sub = create(:subsidiary)
        user = build(:user, role: :employee, subsidiary: sub)
        car = build(:car, subsidiary: sub)
        
        result = described_class.new(car, user).authorized?
        
        expect(result).to eq false
      end
    end

    context 'guest' do
      it 'should return false for guest user' do
        guest = NilUser.new
        car = build(:car)

        result = described_class.new(car, guest).authorized?

        expect(result).to eq false
      end
    end
  end
end