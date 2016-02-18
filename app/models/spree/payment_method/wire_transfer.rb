module Spree
  class PaymentMethod::WireTransfer < PaymentMethod
    preference :bank_name, :string
    preference :account_number, :string
    def payment_source_class
      Spree::User
    end

    def method_type
      "wire_transfer"
    end

    def can_credit?
      true
    end

    def auto_capture?
      false
    end

    def source_required?
      true
    end

    def get_source(user_id)
      Spree::User.find(user_id)
    end

    def authorize(money, credit_card, options = {})
      ActiveMerchant::Billing::Response.new(true, "Los requisitos de transferencia: Banco #{self.preferred_bank_name} Cta# #{self.preferred_account_number} Valor #{money}")
    end
  end
end