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

  def edit
    @discount = Discount.find(params[:discount_id])
  end

  def update
    @discount = Discount.find(params[:discount_id])
    if @discount.update(discount_params)
      redirect_to '/merchant/discounts'
    else
      flash[:unsucessful] = @discount.errors.full_messages.uniq.to_sentence
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:discount_id])
    discount.destroy
    flash[:sucess] = 'Discount is sucessfully deleted'
    redirect_to '/merchant/discounts'
  end

  private

  def discount_params
    params.require(:discount).permit(:name ,:quantity, :discount)
  end
end
