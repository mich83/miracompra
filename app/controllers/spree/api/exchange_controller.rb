module Spree
  module Api
    class ExchangeController < BaseController
      respond_to :xml, :json
      def new_message
          last_message = ExchangeMessage.where(:confirmed => true).order(id: :desc).first
          start_time = last_message.date_time unless last_message.nil?
          @result = {:message_no => 0, :objects => []}
          add_objects(Spree::Product, start_time,@result, [:id, :name, :plan_info])
          add_objects(Spree::Variant, start_time,@result, [:id, :sku, :product_id])
          add_objects(Spree::User, start_time, @result, [:id, :email, :full_name, :document, :phone, :mobile, :referred_by_id])
          add_objects(UserAccount, start_time, @result, [:id, :account_type, :spree_user_id])
          add_objects(Spree::Order, start_time, @result, [:id, :number, :created_by_id, :created_at, :payment_state, :items])
          add_objects(Spree::Payment, start_time, @result, [:id, :number, :order_id, :amount, :state, :source_type, :updated_at, :created_at, :payment_method])

          if @result[:objects].count != 0
            msg = ExchangeMessage.new
            msg.date_time = DateTime.now
            msg.confirmed  =false
            msg.save!
            @result[:message_no] = msg.id
          end
          respond_with @result
      end

      def confirm
        msg = ExchangeMessage.find(params[:msg_no])
        if msg.nil?
          @result = {result: "Invalid message id"}
        else
          msg.confirmed = true
          msg.save!
          @result = {result: "OK"}
        end
        respond_with @result
      end

      def set_plan
        @result = {result: "OK"}
        client = Spree::User.find(params[:client_id])
        client.plan = params[:plan].strip!;
        begin
          client.save!
        rescue
          @result = {result: "FAILED"}
        end
        respond_with @result
      end

      def confirm_payment
        payment = Spree::Payment.find_by_number(params[:payment_id].strip!)
        payment.complete
        @result = {result: "OK"}

        respond_with @result
      end

      def user_stats
        stat = Spree::UserStat.find_by_spree_user_id(params[:spree_user_id])
        if stat.nil?
          stat = Spree::UserStat.new(stat_params)
        else
          stat.update(stat_params)
        end
        begin
          stat.save!
          @result = {result: "OK"}
        rescue
          @result = {result: "FAILED"}
        end
        respond_with @result

      end

      def user
        user = Spree::User.find_by_id(params[:id])
        if user.nil?
          @result = {}
        else
          @result = {:class => Spree::User.class_name, :obj => get_object_hash(user, [:id, :email, :full_name, :document, :phone, :mobile, :referred_by_id])}
        end
        respond_with @result
      end

      private

      def stat_params
        p = params.permit([:spree_user_id, :comisiones, :bono, :comercializacion, :c_limite, :esp_recompra, :esp_factura, :acreditado])
        p.each_key { |k| p[k] = p[k].to_i.to_f/100 unless k == "spree_user_id"}
        p
      end

      def add_objects(class_name, start_time, objects, attributes)
        get_objects(class_name, start_time).find_each do |obj|
          objects[:objects] << {:class => class_name.class_name, :obj => get_object_hash(obj, attributes) }
        end
      end
      def get_objects(class_name, start_time)
        if start_time.nil?
          class_name.all
        else
          class_name.where('updated_at > ?', start_time)
        end
      end
      def get_object_hash(obj, attributes)
        if attributes.nil?
          obj.attributes
        else
          result = Hash.new
          attributes.each do |attr|
            result[attr] = obj.method(attr).call
          end
          result
        end
      end
    end
  end
end