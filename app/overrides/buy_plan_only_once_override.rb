Spree::LineItem.class_eval do
  before_save :check_plan

  def check_plan
    if !self.product.is_real? && self.quantity > 1
      self.quantity = 1
    end
  end
end