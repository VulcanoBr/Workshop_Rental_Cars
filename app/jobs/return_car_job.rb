class ReturnCarJob
  def perform
    RentalMailer.send_rental_receipt()
  end

  def self.auto_queue(rental_id)
    Delayed::Job.enqueue(ReturnCarJob.new(rental_id))
  end

  private

  attr_reader :rental

  def initialize(rental_id)
    @rental = Rental.find(rental_id)
  end

end