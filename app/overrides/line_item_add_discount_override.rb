Spree::LineItem.class_eval do
  before_save :check_discount

  def check_discount
    if order.user && !order.user.plan.blank?
      discount = Spree::Discount.get_discount(variant).to_f/100
      self.price = (variant.price*(1-discount))
    end
  end
end