module Spree
  module Api
    class AccountPaymentsController < Spree::Api::BaseController
      respond_to :xml, :json
      before_action :require_admin
      def index
        if params[:ids]
          @payments = AccountPayment.where(id: params[:ids].split(",").flatten)
        else
          @payments = AccountPayment.ransack(params[:q]).result
        end

        @payments = @accounts.distinct.page(params[:page]).per(params[:per_page])
        expires_in 15.minutes, :public => true
        headers['Surrogate-Control'] = "max-age=#{15.minutes}"
        respond_with(@payments)
      end

      def show
        @payment = AccountPayment.find(params[:id])
        expires_in 15.minutes, :public => true
        headers['Surrogate-Control'] = "max-age=#{15.minutes}"
        headers['Surrogate-Key'] = "product_id=1"
        respond_with(@payment)
      end

      def create
        authorize! :create, AccountPayment
        params[:transaction][:available_on] ||= Time.now
        @payment = AccountPayment.new(transaction_params)

        @payment.save

        if @payment.persisted?
          respond_with(@payment, :status => 201, :default_template => :show)
        else
          invalid_resource!(@payment)
        end
      end

      def update
        @payment = AccountPayment.find(params[:id])
        authorize! :update, @transaction

        @payment.update(account_params)

        if @payment.errors.empty?
          respond_with(@payment.reload, :status => 200, :default_template => :show)
        else
          invalid_resource!(@payment)
        end
      end

      def update_recordset

        begin
          params[:recordset].each_key do |no|
            recordset = params[:recordset][no]
            doc_ref = recordset[:doc_ref]
            AccountPayment.where(:document_ref => doc_ref).destroy_all
            recordset[:records].each_key do |index|
              record = recordset[:records][index]
              payment = AccountPayment.new(record.permit(:document_ref, :user_account_id, :value, :reason))
              payment.save
            end
          end
          @result = {status: :OK}
        rescue
          @result = {status: :error}
        end
        respond_with(@result)
      end

      def destroy
        @account = UserAccount.find(params[:id])
        authorize! :destroy, @account
        @account.destroy
        respond_with(@account, :status => 204)
      end

      private

      def account_params
        params.require(:account_payment).permit(permitted_account_attributes)
      end

      def require_admin
        head :forbidden  unless current_api_user.admin?
      end

      def permitted_account_attributes
        [
            :id,
            :user_account_id,
            :document_ref,
            :value,
            :reason
        ]
      end
    end
  end
end