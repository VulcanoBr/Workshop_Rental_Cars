class Car < ApplicationRecord
  belongs_to :car_model
  belongs_to :subsidiary
  has_many :maintenances, dependent: :destroy
  has_many :inspections, dependent: :destroy
  has_many :fines, dependent: :destroy
  has_many :rentals, dependent: :destroy

  enum status: { available: 0, scheduled: 3, on_maintenance: 5, rented: 10 }

  validates :car_model, :car_km, :color, :license_plate, presence: true

  validate :car_km_can_not_be_less_than_actual, on: :update

  scope :cars_by_status, -> {
    stats_query = <<-SQL
      SELECT
        COUNT(*) AS total,
        SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS total_available,
        SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS total_scheduled,
        SUM(CASE WHEN status = 5 THEN 1 ELSE 0 END) AS total_in_maintenance,
        SUM(CASE WHEN status = 10 THEN 1 ELSE 0 END) AS total_allocated,
        (SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS available_percentage,
        (SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS scheduled_percentage,
        (SUM(CASE WHEN status = 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS in_maintenance_percentage,
        (SUM(CASE WHEN status = 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS allocated_percentage
      FROM cars
      SQL
    
      find_by_sql(stats_query)
    
  }
  
  scope :cars_by_subsidiary_and_status, -> {
    joins(:subsidiary)
    .select(
      "subsidiaries.name AS subsidiary_name",
      "COUNT(*) AS total_cars",
      "SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS total_available",
      "SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS total_scheduled",
      "SUM(CASE WHEN status = 5 THEN 1 ELSE 0 END) AS total_in_maintenance",
      "SUM(CASE WHEN status = 10 THEN 1 ELSE 0 END) AS total_allocated",
      "(SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage_available",
      "(SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage_scheduled",
      "(SUM(CASE WHEN status = 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage_in_maintenance",
      "(SUM(CASE WHEN status = 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage_allocated"
    )
    .group("subsidiaries.name")
  }

  scope :with_available_status_and_price, ->(name = nil) {
    joins(:subsidiary, :car_model)
      .where(status: 'available')
      .where(name.nil? ? nil : ["LOWER(car_models.name) LIKE ?", "%#{name.downcase}%"])
      .joins("INNER JOIN subsidiary_car_models ON cars.subsidiary_id = subsidiary_car_models.subsidiary_id AND cars.car_model_id = subsidiary_car_models.car_model_id")
      .select("cars.*, subsidiary_car_models.price as car_price")
      .order("car_models.name")
  }

  def car_identification
    "#{car_model.name} - #{license_plate} - #{car_model.category}"
  end

  def current_maintenance
    maintenances.last if on_maintenance?
  end

  private 

  def car_km_can_not_be_less_than_actual
    return unless car_km < car_km_was

    errors.add(:car_km, 'Quilometragem não pode ser menor que a atual')
  end
end
