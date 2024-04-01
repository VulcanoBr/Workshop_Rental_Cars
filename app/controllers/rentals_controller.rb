class RentalsController < ApplicationController

  def new
    @rental = Rental.new
    @cars = car_user  #current_user.subsidiary.cars.available
    @customers = Customer.order_by_name   ##.sort_by { |customer| customer.name }
  end

  def create
    @rental = current_user.rentals.new(rental_params)
    daily_price = @rental.car.car_model.subsidiary_car_models.first
    @rental.daily_price = daily_price.price
    @rental.rented_code = Date.today.year.to_s + SecureRandom.alphanumeric(11).upcase
    if @rental.save
      @rental.car.scheduled!
      RentalMailer.send_rental_receipt(@rental.id).deliver_now
      flash[:notice] = 'Um email de confirmação foi enviado para o cliente'
      return redirect_to @rental
    end
    @cars = car_user
    @customers = Customer.order_by_name
    render :new
  end

  def subsidiary_finances
    if !Rental.exists? || params[:year].blank?
      return @costs_by_sub = {}
    end
    year = params[:year]
    daily_cost_results = Rental.calculate_daily_cost_by_year(year).index_by(&:id)
    maintenance_cost_results = Maintenance.calculate_maintenance_cost_by_year(year).index_by(&:id)
    fines_cost_results = Fine.calculate_fines_cost_by_year(year).index_by(&:id)

    @subsidiaries = Subsidiary.all

    @costs_by_sub = {}

    @subsidiaries.each do |subsidiary|
      @costs_by_sub[subsidiary.id] = {
        subsidiary_name: subsidiary.name,
        daily_price: daily_cost_results[subsidiary.id]&.total_daily_cost || 0,
        rentals_count: daily_cost_results[subsidiary.id]&.rentals_count || 0,
        maintenance_value: maintenance_cost_results[subsidiary.id]&.total_maintenance_cost || 0,
        maintenance_count: maintenance_cost_results[subsidiary.id]&.maintenance_count || 0,
        fines_value: fines_cost_results[subsidiary.id]&.total_fine_cost || 0,
        fines_count: fines_cost_results[subsidiary.id]&.fines_count || 0
    }
    end  
    @costs_by_sub
  end

  def scheduled_cars
    @rental_status_cars = params[:rented_code].present? ? Rental.scheduled(params[:rented_code]) : Rental.scheduled
  end

  def rented_cars
    @rental_status_cars = params[:rented_code].present? ? Rental.rented(params[:rented_code]) : Rental.rented
  end

  def withdraw
    @rental = Rental.find(params[:id])
    @rental.update(started_at: Time.zone.now)
    @rental.active!
    @rental.car.rented!
    redirect_to @rental
  end

  def location_canceled
    @rental = Rental.find(params[:id])
    @rental.update(finished_at: Time.zone.now, started_at: Time.zone.now, ended_at: Time.zone.now)
    @rental.canceled!
    @rental.car.available!
    RentalMailer.send_location_canceled(@rental.id).deliver_now
    flash[:notice] = 'Um email de cancelamento foi enviado para o cliente'
    flash[:success] = 'Locação cancelada com sucesso !!!'
    redirect_to root_path
  end

  def show
    rental = Rental.find(params[:id])
    @rental = RentalPresenter.new(rental)
  end

  def new_car_return
    @car = Rental.find(params[:id]).car
  end

  def return_car
    @rental = Rental.find(params[:id])
    @car = @rental.car
    if @car.update(car_km: params[:car][:car_km], status: :available)
      @rental.update(finished_at: Time.zone.now, ended_at: Time.zone.now, status: :finished )
      RentalMailer.send_return_receipt(@rental.id).deliver_now
      redirect_to @rental.car, notice: 'Carro devolvido com sucesso'
    else
      flash.now[:notice] = 'Nao foi possivel salvar'
      render :new_car_return
    end
  end

  private

  def car_user
    current_user.admin? ? Car.where(status: "available").includes(:car_model).order("car_models.name") : current_user.subsidiary.cars.available 
  end

  def rental_params
    params.require(:rental).permit(:car_id, :user_id, :customer_id, :rented_code, :daily_price, :start_at, 
                  :finished_at, :status, :scheduled_start, :scheduled_end, :started_at, :ended_at)
  end
end
