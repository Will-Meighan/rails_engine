class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.most_revenue(params[:quantity]))
  end

  def show
    render json: MerchantRevenueSerializer.new(Merchant.find(params[:id]))
  end
end
