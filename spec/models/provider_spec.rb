require 'rails_helper'

RSpec.describe Provider, type: :model do

  it 'validates presence of name and cnpj' do
    provider = build(:provider, name: nil, cnpj: '18.187/641.0001.62', email: 'vulcan@email.com' )
    expect(provider).not_to be_valid
    expect(provider.errors[:name]).to include("não pode ficar em branco")

    provider = build(:provider, cnpj: nil, email: 'vulcan@email.com')
    expect(provider).not_to be_valid
    expect(provider.errors[:cnpj]).to include("não pode ficar em branco")
  end

  it 'validates length of cnpj = 18' do
    provider = build(:provider, cnpj: "18187641/0001-62", email: 'vulcan@email.com')
    expect(provider).not_to be_valid
    expect(provider.errors[:cnpj][0]).to include("não possui o tamanho esperado (18 caracteres)")
    expect(provider.errors[:cnpj][1]).to include("não está no formato correto (99.999.999/9999-99)")
  end

  it 'validates format of cnpj = 99.999.999/9999-99' do
    provider = build(:provider, cnpj: "18.187/641.0001.62", email: 'vulcan@email.com')
    expect(provider).not_to be_valid
    expect(provider.errors[:cnpj][0]).to include("não está no formato correto (99.999.999/9999-99)")
  end
end
