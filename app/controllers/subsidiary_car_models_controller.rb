class SubsidiaryCarModelsController < ApplicationController
  def show
    @subsidiary_car_model = SubsidiaryCarModel.find params[:id]
  end

  def new
    @subsidiary_car_model = SubsidiaryCarModel.new
    @car_models = CarModel.with_name_and_category
  end

  def create
    @subsidiary_car_model = SubsidiaryCarModel.new subsidiary_params
    @subsidiary_car_model.subsidiary_id = current_user.subsidiary_id
    if @subsidiary_car_model.save
      redirect_to @subsidiary_car_model
      flash[:alert] = 'Preço cadastrado com sucesso'
    else
      @car_models = CarModel.with_name_and_category
      render :new
    end
  end

  private

  def subsidiary_params
    params.require(:subsidiary_car_model)
          .permit(%i[price car_model_id])
  end
end
