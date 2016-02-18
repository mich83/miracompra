Spree::Referral.class_eval do
  def referred_orders
    referred_records_with_user_orders.collect{|u| u.user.orders unless u.user.nil? }.flatten.compact
  end

end