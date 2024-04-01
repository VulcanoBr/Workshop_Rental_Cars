class RentalDecorator < ApplicationDecorator
  delegate_all

  def started_at
    return '---' if object.scheduled?

    object.started_at.strftime("%d/%m/%Y")
  end
end