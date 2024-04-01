require 'rails_helper'

RSpec.describe Address, type: :model do
  it "validates presence of street, number, neighborhood, city and state" do
    address = build(:address, street: nil, number: nil, neighborhood: nil, city: nil, state: nil)
    expect(address).not_to be_valid
    expect(car.errors.full_messages).to include(
      "Logradouro não pode ficar em branco",
      "Número não pode ficar em branco",
      "Bairro não pode ficar em branco",
      "Cidade não pode ficar em branco",
      "Estado não pode ficar em branco"
    )
  end

  it 'validates presence of street' do
    address = build(:address, street: nil)
    expect(address).not_to be_valid
    expect(address.errors[:street]).to include("não pode ficar em branco")
  end
  
  it 'validates presence of number' do
    address = build(:address, number: nil)
    expect(address).not_to be_valid
    expect(address.errors[:number]).to include("não pode ficar em branco")
  end

  it 'validates presence of neighborhood' do
    address = build(:address, neighborhood: nil)
    expect(address).not_to be_valid
    expect(address.errors[:neighborhood]).to include("não pode ficar em branco")
  end

  it 'validates presence of city' do
    address = build(:address, city: nil)
    expect(address).not_to be_valid
    expect(address.errors[:city]).to include("não pode ficar em branco")
  end

  it 'validates presence of state' do
    address = build(:address, state: nil)
    expect(address).not_to be_valid
    expect(address.errors[:state]).to include("não pode ficar em branco")
  end

end