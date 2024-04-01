class Rental < ApplicationRecord
  belongs_to :car
  belongs_to :user
  belongs_to :customer

  validates :customer_id, :car_id, presence: true

  validates :scheduled_start, :scheduled_end, presence: true
  validates :scheduled_start, :scheduled_end, comparison: { greater_than_or_equal_to: -> { Date.today } }, on: :create
  validates :scheduled_end, comparison: { greater_than_or_equal_to: :scheduled_start }, on: :create

  validate :customer_has_active_rental, on: :create,  if: -> { customer_id.present? }

  enum status: { scheduled: 0, active: 5, finished: 10, canceled: 15 }

  scope :scheduled, ->(rented_code = nil) {
    joins(:car)
      .where(cars: { status: :scheduled }, rentals: { status: :scheduled })
      .where(rented_code.present? ? ['UPPER(rented_code) = ?', rented_code.upcase] : {})
  }

  scope :rented, ->(rented_code = nil) {
    joins(:car)
      .where(cars: { status: :rented }, rentals: { status: :active })
      .where(rented_code.present? ? ['UPPER(rented_code) = ?', rented_code.upcase] : {})
  }

  scope :finished_within_current_year, -> {
    where(status: 'finished')
    .where("EXTRACT(YEAR FROM ended_at) = ?", Time.now.year)
    .where("EXTRACT(YEAR FROM started_at) = ?", Time.now.year)
  }

  scope :finished_in_year, ->(year) {
    where(status: 'finished')
      .where("EXTRACT(YEAR FROM ended_at) = ?", year)
      .where("EXTRACT(YEAR FROM started_at) = ?", year)
  }
  
  scope :calculate_daily_cost_by_year, ->(year) {
    joins(:car)
      .joins('INNER JOIN cars ON rentals.car_id = cars.id')
      .joins('INNER JOIN subsidiaries ON cars.subsidiary_id = subsidiaries.id')
      .where(status: 'finished') 
      .where("EXTRACT(YEAR FROM rentals.started_at) = ?", year)
      .where("EXTRACT(YEAR FROM rentals.ended_at) = ?", year)
      .select('subsidiaries.id,
              SUM(rentals.daily_price * (EXTRACT(DAY FROM(rentals.ended_at - rentals.started_at))) ) AS total_daily_cost,
              COUNT(*) AS rentals_count')
      .group('subsidiaries.id')
  }
  
  private

  def customer_has_active_rental
    return unless customer.personal_customer?
    
    if customer.active_rental?
      errors.add(:customer_id, 'possui locação em aberto')
    end
  end
end
