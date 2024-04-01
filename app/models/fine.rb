class Fine < ApplicationRecord
  belongs_to :car
  has_one :credit, as: :transactable, dependent: :destroy

  validates :issued_on, :demerit_points, :fine_value, :address, presence: true

  scope :within_current_year, -> {
    where("EXTRACT(YEAR FROM issued_on) = ?", Time.now.year.to_s)
  }

  scope :calculate_fines_cost_by_year, ->(year) {
      joins(car: :subsidiary)
        .where("EXTRACT(YEAR FROM issued_on) = ?", year)
        .select('subsidiaries.id', 'SUM(fine_value) as total_fine_cost', 'COUNT(*) as fines_count')
        .group('subsidiaries.id')
  }
  
end
