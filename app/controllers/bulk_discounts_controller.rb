class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    bulk_discount = Merchant.find(params[:merchant_id]).bulk_discounts
                                                       .new(bulk_discount_params)

    if bulk_discount.save
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
    else
      flash[:alert] = "Bulk Discount could not be created"
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/new"
    end
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])

    bulk_discount.update(
      quantity_threshold: params[:quantity],
      percentage_discount: params[:percent]
      )

    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/#{params[:id]}"
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy!
    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
  end

  private
    def bulk_discount_params
      params.permit(:quantity_threshold, :percentage_discount)
    end
end
