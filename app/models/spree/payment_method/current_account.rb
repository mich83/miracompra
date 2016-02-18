module Spree
  class PaymentMethod::CurrentAccount < PaymentMethod
    require 'net/http'
    preference :account_type, :string
    def payment_source_class
      UserAccount
    end

    def method_type
      "currentaccount"
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
      UserAccount.where(:spree_user_id => user_id, :account_type => preferred_account_type.to_sym).first
    end
    def purchase(amount_cents, source, gateway_options)
        url = URI("#{Spree::Config::report_server}/#{Spree::Config::report_infobase}/hs/authorize/authorize")
        params = {
            :token => Spree::Config::report_token,
            :amount_cents => amount_cents,
            :account_id => source.id,
            :reason => "Compra ##{gateway_options[:order_id]}"
        }
        Rails.logger.debug url.inspect
        req = Net::HTTP::Post.new(url)
        req.set_form_data(params)
        req.basic_auth Spree::Config::report_user, Spree::Config::report_password


        resp = Net::HTTP.start(url.hostname, url.port, :use_ssl => url.scheme == 'https') do |http|
          http.request(req)
        end
        Rails.logger.debug "Server response: #{resp.inspect}"
        if resp.code == '200'
          new_balance = resp.body.to_f/100
          source.balance = new_balance
          source.save!
          success
        elsif resp.code == '401'
          fail(Spree.t(:wrong_token))
        elsif resp.code == '403'
          fail(Spree.t(:forbidden))
        else
          fail(Spree.t(:server_error))
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