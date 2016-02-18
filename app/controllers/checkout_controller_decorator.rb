Spree::CheckoutController.class_eval do
  def registration
    @user = Spree::User.new
    Rails.logger.debug "REFERRAL #{session[:referral]}"
    @ref_code = session[:referral]
  end
end