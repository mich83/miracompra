Spree::UserRegistrationsController.class_eval do
  before_filter :check_referral_and_affiliate, :only => :create
  def new
    #super
    build_resource
    @user = resource
    @products = Spree::Product.where(:high_demand => true).first(4)
    @ref_code = session[:referral]
  end

  # POST /resource/sign_up
  def create
    @user = build_resource(spree_user_params)
    if resource.save
      set_flash_message(:notice, :signed_up)
      sign_in(:spree_user, @user)
      session[:spree_user_signup] = true
      associate_user
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      @products = Spree::Product.where(:high_demand => true).first(4)
      render :new
    end
  end

  def check_referral_and_affiliate
#    if Spree::Referral.find_by_code(params[:ref_code]).nil?
#      ref_code = nil
#    else
    ref_code = params[:ref_code]
#    end
    Rails.logger.debug "REF-CODE #{ref_code}"
    params[:spree_user].merge!(:referral_code => ref_code, :affiliate_code => session[:affiliate])
  end

  def spree_user_params
    params.require(:spree_user).permit([:email, :password, :password_confirmation, :full_name, :birth_date, :phone, :mobile, :document, :referral_code])
  end

end