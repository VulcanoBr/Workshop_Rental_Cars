class CarModel < ApplicationRecord
  belongs_to :manufacture
  has_many :subsidiary_car_models, dependent: :destroy

  validates :name, :year, :car_options, :category, presence: true
  validates :year, length: { in: 4..9 }
  validates :year, format: { with: /\d{4}/, if: -> { year.length <= 4 } }
  validates :year, format: { with: /\d{4}\/[0-9]{4}/, if: -> { year.length > 4 } }
  validates :manufacture_id, presence: true

  scope :with_name_and_category, -> { select("id, CONCAT(name, ' - ', year, ' - ', category) AS name").order(:name) }

  scope :with_available_cars, -> { where(cars: { status: 'available' }) }

end
