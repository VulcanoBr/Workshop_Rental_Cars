class HomeController < ApplicationController
  def index
    if Car.exists?
      @cars_status = Car.cars_by_status.first
    else
      @cars_status = default_car_status
    end
    @cars_by_subsidiary_and_status = Car.cars_by_subsidiary_and_status
    if Customer.exists?
      @customers_by_type = Customer.customers_by_type.first
    else
      @customers_by_type = default_customers_by_type
    end
    @total_daily_price = Rental.finished_within_current_year.sum do |rental|
      days = (rental.ended_at.to_date - rental.started_at.to_date).to_i
      days == 0 ? rental.daily_price : rental.daily_price * days
    end
    @total_service_cost = Maintenance.within_current_year.sum(:service_cost)
    @total_fine_value = Fine.within_current_year.sum(:fine_value)
    @total_cost = @total_daily_price - (@total_service_cost + @total_fine_value)
  end

  private

  def default_car_status
    OpenStruct.new(
      total: 0,
      total_available: 0,
      total_scheduled: 0,
      total_in_maintenance: 0,
      total_allocated: 0,
      available_percentage: 0,
      scheduled_percentage: 0,
      in_maintenance_percentage: 0,
      allocated_percentage: 0
    )
  end

  def default_customers_by_type
    OpenStruct.new(
      total_personal: 0,
      total_company: 0,
      personal_percentage: 0,
      company_percentage: 0,
    )
  end

end
