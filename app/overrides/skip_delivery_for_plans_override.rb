Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address, if: -> (order){ !order.only_plans?}
    go_to_state :delivery, if: ->(order){ !order.only_plans?}
    go_to_state :payment, if: ->(order) { order.payment_required? }
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }

    go_to_state :complete
    remove_transition from: :delivery, to: :confirm
  end

  def only_plans?
    line_items.each do |line|
      return false if line.product.is_real?
    end
    return true
  end

end