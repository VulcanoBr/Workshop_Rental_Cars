class CarPresenter < SimpleDelegator
  include Rails.application.routes.url_helpers

  def initialize(car, user)
    super(car)
    @user = user
  end

  def maintenance_link
    if @user.admin? && available?
      return new_car_maintenance_path(id)
    elsif @user.admin? && !available? && current_maintenance.present?
      return new_return_maintenance_path(current_maintenance)
    else
      return ''
    end
  end
  

  private

  attr_reader :user
end