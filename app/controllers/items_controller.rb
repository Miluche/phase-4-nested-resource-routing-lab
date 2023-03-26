class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  def index
    items = Item.all
    render json: items, include: :user
  end

  def show
    item = Item.find_by(id: params[:id])
    render json: item
  end

  def create
    item = Item.create!(item_params)
    render json: item, status: :created
  end

  private
  def render_not_found_response
    render json: {error: "Item not found"}, status: :not_found
  end
  def item_params
    params.permit(:name, :description, :price, :user)
  end

  def render_unprocessable_entity_response(invalid)
    render json: {errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
