class Inspection < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :fuel_level, :cleanance_level, :damages, presence: true

  validates :fuel_level, :cleanance_level, numericality: { only_integer: true }

end
