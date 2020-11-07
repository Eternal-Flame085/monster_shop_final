class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = Discount.all
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = current_user.merchant
    @discount = merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to '/merchant/discounts'
    else
      flash[:unsucessful] = @discount.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:name ,:quantity, :discount)
  end
end
