class MerchantItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
    @item = Item.find(params[:item_id])
  end

  def edit
    @item = Item.find(params[:item_id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def update
    item = Item.find(params[:item_id])

    if params[:enable]
      item.update!(status: 1)
      redirect_to "/merchants/#{item.merchant_id}/items"
    elsif params[:disable]
      item.update!(status: 0)
      redirect_to "/merchants/#{item.merchant_id}/items"

    else
      if item.update!(item_params)
        flash[:alert] = "Information has been successfully updated"
        redirect_to "/merchants/#{item.merchant_id}/items/#{item.id}"
      end

    end
  end

  def create
    item = Merchant.find(params[:id]).items.new(item_params)

    if params[:name].length > 0 && item.save
      redirect_to "/merchants/#{params[:id]}/items"
    else
      flash[:alert] = "Item could not be created"
      redirect_to "/merchants/#{params[:id]}/items/new"
    end
  end

  private
    def item_params
      params.permit(:name, :description, :unit_price)
    end
end
