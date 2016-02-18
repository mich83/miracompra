module Spree
  module Api
    class UserAccountsController < Spree::Api::BaseController
      respond_to :xml, :json
      before_action :require_admin
      def index
        if params[:ids]
          @accounts = UserAccount.where(id: params[:ids].split(",").flatten)
        else
          @accounts = UserAccount.ransack(params[:q]).result
        end

        @accounts = @accounts.distinct.page(params[:page]).per(params[:per_page])
        expires_in 15.minutes, :public => true
        headers['Surrogate-Control'] = "max-age=#{15.minutes}"
        respond_with(@accounts)
      end

      def show
        @account = UserAccount.find(params[:id])
        expires_in 15.minutes, :public => true
        headers['Surrogate-Control'] = "max-age=#{15.minutes}"
        headers['Surrogate-Key'] = "product_id=1"
        respond_with(@account)
      end

      def create
        authorize! :create, UserAccount
        params[:transaction][:available_on] ||= Time.now
        @account = UserAccount.new(transaction_params)

        @account.save

        if @account.persisted?
          respond_with(@account, :status => 201, :default_template => :show)
        else
          invalid_resource!(@account)
        end
      end

      def update
        @account = UserAccount.find(params[:id])
        authorize! :update, @transaction

        @account.update(account_params)

        if @account.errors.empty?
          respond_with(@account.reload, :status => 200, :default_template => :show)
        else
          invalid_resource!(@account)
        end
      end

      def destroy
        @account = UserAccount.find(params[:id])
        authorize! :destroy, @account
        @account.destroy
        respond_with(@account, :status => 204)
      end

      private

      def account_params
        params.require(:user_account).permit(permitted_account_attributes)
      end

      def require_admin
        head :forbidden  unless current_api_user.admin?
      end

      def permitted_account_attributes
        [
            :id,
            :spree_user_id,
            :account_type,
            :balance
        ]
      end
    end
  end
end