class Api::V1::Items::SearchController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.get_item_by(search_params))
  end

  def index
    render json: ItemSerializer.new(Item.get_all_items_by(search_params))
  end

  private

    def search_params
      params.permit(:id, :description, :name, :created_at, :updated_at, :merchant_id)
    end
end
