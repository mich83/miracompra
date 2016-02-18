Spree::Order.class_eval do
  has_many :spree_credit_card_payments, :foreign_key => 'spree_order_id', :class_name => 'Spree::CreditCardPayment', :dependent => :destroy
  def items
    result = Array.new
    line_items.each do |line_item|
      full_price = line_item.variant.price_in(currency).price
      price_with_discount = full_price*(1-Spree::Discount.get_discount(line_item.variant).to_f/100)
      result << {product: line_item.variant.product_id, variant: line_item.variant_id, quantity: line_item.quantity, price: line_item.price, tax: line_item.included_tax_total, original_price: full_price, price_with_discount: price_with_discount}
    end
    result
  end
end