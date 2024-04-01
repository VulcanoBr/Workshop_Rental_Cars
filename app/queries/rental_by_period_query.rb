class RentalByPeriodQuery

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def call
    rentals_within_period = Rental.where('(finished_at BETWEEN ? AND ?) OR 
      finished_at = ? OR finished_at = ?', @start_date, @end_date, @start_date, @end_date).where(status: :finished)
      result = {}
    rentals_within_period.group(:car_id).count.each do |car_id, count|
      result[car_id] = count
    end
    return result
  end
end
