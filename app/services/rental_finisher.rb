class RentalFinisher
  def initialize(rental, new_km)
    @rental = rental
    @car = rental.car
    @customer = rental.customer
    @new_km = new_km
  end

  def finish
    car.update!(car_km: new_km, status: :available)
    rental.update(finished_at: Time.zone.now, status: :finished)
    RentalMailer.send_return_receipt(rental.id).deliver_now
  end

  private

  attr_reader :rental, :new_km, :customer, :car
end