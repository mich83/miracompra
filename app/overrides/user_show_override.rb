Spree::UsersController.class_eval do
  def show
    @department = params[:department]
    @department ||= "general_info"
    @orders = @user.orders.complete.order('completed_at desc') if @department == "orders"
    @invitations = Spree::Invitation.where('user_id is null or user_id = ?', @user.id) if @department == "company"
    @available_plans = (@user.available_plans.map {|plan| Spree::Product.where(:plan_info=>@user.plan_description(plan)).first}).compact if @department == "general_info"
    if @department == "company"
      stat = Spree::UserStat.find_by_spree_user_id(@user.id)
      if stat.nil?
        @stats = {}
        s_params = [:comisiones, :bono, :comercializacion, :c_limite, :esp_recompra, :esp_factura, :acreditado]
        s_params.each { |k| @stats[k] = 0.00 }
      else
        @stats = stat.to_hash
      end
    end
  end

  def user_params
    permitted_params = params.require(:user).permit(user_permitted_params)
    if params.require(:user)[:use_billing] == "1"
      bill_address = permitted_params[:bill_address_attributes]
      bill_address.each_pair do |attr, value|
        permitted_params[:ship_address_attributes][attr] = value if attr != "id"
      end

    end
    permitted_params
  end

  def user_permitted_params
    [:email, :password, :password_confirmation, :full_name, :birth_date, :phone, :mobile, :document, bill_address_attributes: Spree::PermittedAttributes.address_attributes, ship_address_attributes: Spree::PermittedAttributes.address_attributes]
  end

end



Spree::Referral.class_eval do

 protected
  def attach_code

    selection_count = PredefinedCode.where(assigned: false).count

    n = rand(selection_count)
    code = PredefinedCode.where(assigned: false).limit(1).offset(n).first
    self.code = code.code
    code.assigned = true
    code.save
  end

end