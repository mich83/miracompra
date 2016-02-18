module Spree
  class PaymentMethod::CreditCardVpos < PaymentMethod
    def payment_source_class
      Spree::User
    end

    def method_type
      "credit_card"
    end

    def can_credit?
      false
    end

    def auto_capture?
      true
    end

    def source_required?
      true
    end

    def get_source(user_id)
      Spree::User.find(user_id)
    end

    def purchase(amount_cents, source, gateway_options)
      Rails.logger.debug "purchase #{amount_cents.inspect} options: #{gateway_options.inspect}"
      order = Spree::Order.find_by_number(gateway_options[:order_id].split("-").first)
      if Spree::CreditCardAuth.where(:order_id => order.id, amount: amount_cents.to_i).any?
        success
      else
        fail
      end
    end

    def success
      ActiveMerchant::Billing::Response.new(true, Spree.t(:payment_successful), {}, {})
    end
    def fail(msg = "")
      ActiveMerchant::Billing::Response.new(false, msg, {}, {})
    end
  end
end