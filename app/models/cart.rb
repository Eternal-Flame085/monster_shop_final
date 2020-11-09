class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def apply_discount(item)
    applied_discount = nil
    item.merchant.order_discounts.each do |discount|
      if @contents[item.id.to_s] >= discount.quantity
        applied_discount = discount
        break
      end
    end
    applied_discount
  end

  def subtotal_discount(item, discount)
    subtotal_of(item.id) - (subtotal_of(item.id) * (discount.discount / 100))
  end

  def price_discount(item, discount)
    (item.price - (item.price * (discount.discount / 100)))
  end
end
