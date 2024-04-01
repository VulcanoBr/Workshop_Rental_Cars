class RentalPresenter < SimpleDelegator
  include Rails.application.routes.url_helpers
  delegate :content_tag, :link_to, to: :helper

  def initialize(rental)
    super(rental)
  end

  def status
    case
    when scheduled?
      content_tag(:span, class: "badge badge-success") do
        "Agendada"
      end
    else
      content_tag(:span, class: "badge badge-primary") do
        "em Andamento"
      end
    end
  end

  def withdraw_link
    links = ""
    if scheduled?
      links =
        link_to('Confirmar Retirada', withdraw_rental_path(id), class: 'btn btn-primary', method: :post) +
        link_to('Cancelar Locação', location_canceled_rental_path(id), class: 'ml-5 btn btn-danger', method: :post)
    end
    links
  end

  private 
  
  attr_reader :rental

  def helper
    ApplicationController.helpers
  end
end