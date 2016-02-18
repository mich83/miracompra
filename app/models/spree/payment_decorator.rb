Spree::Payment.class_eval do
  def build_source
    return unless new_record?
    if source.blank? && payment_method.try(:payment_source_class)
      if payment_method.respond_to?(:get_source) && self.order
        self.source = payment_method.get_source(self.order.user_id)
      elsif source_attributes.present?
        self.source = payment_method.payment_source_class.new(source_attributes)
        self.source.payment_method_id = payment_method.id
        self.source.user_id = self.order.user_id if self.order
      end
    end
  end
end