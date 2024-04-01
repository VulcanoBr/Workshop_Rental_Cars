class Provider < ApplicationRecord
  has_many :maintenances, dependent: :destroy

  validates :name, :email, presence: true 
  
  validates :cnpj, presence: true, cnpj: true, uniqueness: true

  validates :cnpj, length: { is: 18 }

  validates_format_of :cnpj, with: /\A\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}\z/, message: "não está no formato correto (99.999.999/9999-99)"

  scope :search_by_name, ->(name) {
    where("lower(name) LIKE ?", "%#{name.downcase}%")
    .order('name')
  }
  
end
