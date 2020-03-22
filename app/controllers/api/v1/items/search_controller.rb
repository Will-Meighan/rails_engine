class Api::V1::Items::SearchController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.find_first_item(search_params))
  end

  def index
    render json: ItemSerializer.new(Item.find_all_items(search_params))
  end

  private

    def search_params
      params.permit(:id, :description, :name, :created_at, :updated_at, :merchant_id)
    end
end
