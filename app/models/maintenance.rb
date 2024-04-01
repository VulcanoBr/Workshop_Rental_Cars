class Maintenance < ApplicationRecord
  belongs_to :car
  belongs_to :provider
  has_one :debit, as: :transactable, dependent: :destroy

  validates :invoice,
            :service_cost,
            presence: true,
            on: :update

  validates :provider_id, presence: true, on: :create

  scope :cars_on_maintenance, lambda {
    joins(:car).where(cars: { status: :on_maintenance })
  }

  scope :within_current_year, -> {
    where("EXTRACT(YEAR FROM maintenance_date) = ?", Time.now.year.to_s)
  }

  scope :calculate_maintenance_cost_by_year, ->(year) {
      joins(car: :subsidiary)
      .where("EXTRACT(YEAR FROM maintenance_date) = ?", year)
      .select('subsidiaries.id, SUM(service_cost) as total_maintenance_cost, COUNT(*) as maintenance_count')
      .group('subsidiaries.id')
  }

  def car_return(params)
    if update(params)
      car.available!
      create_debit(amount: params[:service_cost],
                    subsidiary: car.subsidiary)
    else
      false
    end
  end
end
