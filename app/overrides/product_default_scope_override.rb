Spree::Product.class_eval do
  scope :real, -> {where("plan_info is null or plan_info = ''")}

  def is_real?
    self.plan_info.nil? || self.plan_info.blank?
  end
end