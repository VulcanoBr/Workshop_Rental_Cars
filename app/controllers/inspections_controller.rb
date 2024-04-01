class InspectionsController < ApplicationController
  def new
    @car = Car.find(params[:car_id])
    @inspection = Inspection.new
  end

  def create
    @car = Car.find(params[:car_id])
    @inspection = @car.inspections.build(inspection_params)
    @inspection.user = current_user
    if @inspection.save
      @inspection.car.available!
      redirect_to @car
      flash[:success] = 'Veiculo Vistoriado com sucesso'
    else
      flash[:error] = 'Você deve preencher todos os campos'
      render :new
    end
  end

  private

  def inspection_params
    params.require(:inspection).permit(:fuel_level, :cleanance_level, :damages)
  end
end
