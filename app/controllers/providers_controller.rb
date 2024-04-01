class ProvidersController < ApplicationController

  before_action :set_provider, only: %i[show edit update destroy]

  def index
    @providers = params[:name].present? ? Provider.search_by_name(params[:name]) : Provider.all.order(:name)
  end

  def new
    @provider = Provider.new
  end

  def show
  end

  def edit
  end

  def create
    @provider = Provider.new(provider_params)
    if @provider.save
      redirect_to @provider
      flash[:success] = 'Fornecedor cadastrado com sucesso'
    else
      flash[:error] = 'Você deve preencher todos os campos'
      render :new
    end
  end

  def update
    if @provider.update(provider_params)
      redirect_to @provider
      flash[:success] = 'Fornecedor editado com sucesso'
    else
      flash[:error] = 'Você deve preencher todos os campos'
      render :edit
    end
  end

  def destroy
  end

  private

  def set_provider
    @provider = Provider.find(params[:id])
  end

  def provider_params
    params.require(:provider).permit(:name, :cnpj, :email, :phone)
  end
end
