class ShipmentsController < BaseController
  before_action :set_shipment

  def update
    if @shipment.update(shipped: true)
      Mailers::ShipmentReadyJob.perform_later(shipment: @shipment)
      redirect_to root_url, alert: "L'envoi a bien été marqué comme livré"
    else
      redirect_to root_url, alert: "Une erreur est survenue"
    end
  end

  private

  def set_shipment
    @shipment ||= Shipment.not_shipped.find_by!(id: params[:id], token: params[:token])
  end
end
