# spec/models/inspection_spec.rb
require 'rails_helper'

RSpec.describe Inspection, type: :model do
  describe 'validations' do
    it 'should require fuel_level, cleanance_level, and damages' do
      inspection = build(:inspection, fuel_level: nil, cleanance_level: nil, damages: nil)
      expect(inspection).not_to be_valid
      expect(inspection.errors[:fuel_level]).to include("não pode ficar em branco")
      expect(inspection.errors[:cleanance_level]).to include("não pode ficar em branco")
      expect(inspection.errors[:damages]).to include("não pode ficar em branco")
    end

    it 'should ensure fuel_level is numeric' do
      inspection = build(:inspection, fuel_level: 'invalid')
      expect(inspection).not_to be_valid
      expect(inspection.errors[:fuel_level]).to include("não é um número")
    end

    it 'should ensure cleanance_level is numeric' do
      inspection = build(:inspection, cleanance_level: 'invalid')
      expect(inspection).not_to be_valid
      expect(inspection.errors[:cleanance_level]).to include("não é um número")
    end

    it 'should not allow blank fuel_level' do
      inspection = build(:inspection, fuel_level: '')
      expect(inspection).not_to be_valid
      expect(inspection.errors[:fuel_level]).to include("não pode ficar em branco")
    end

    it 'should not allow blank cleanance_level' do
      inspection = build(:inspection, cleanance_level: '')
      expect(inspection).not_to be_valid
      expect(inspection.errors[:cleanance_level]).to include("não pode ficar em branco")
    end
  end
end
