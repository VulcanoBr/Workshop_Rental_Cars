class SubsidiaryCarModel < ApplicationRecord
  belongs_to :subsidiary
  belongs_to :car_model

  validates :price, presence: true #{ message: 'Preço não pode ficar em branco' }
  validates :car_model, presence: true 
end
