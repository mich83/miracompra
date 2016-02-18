class Spree::VposController < Spree::BaseController
  layout 'whatever'
  require 'net/http'
  protect_from_forgery :except => :callback

  def do_payment
    fields = [:first_name, :last_name, :email, :address, :zip, :city, :state, :country, :phone]


    order = Spree::Order.find(params[:order_id])
    operation = Spree::CreditCardPayment.create
    operation.spree_order_id = order.id
    operation.value = order.total*100.to_i
    operation.save!

    uri = URI.parse("http://127.0.0.1:8888")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/encode")
    request.add_field('Content-Type', 'application/json')
    request.body = {'total' => (order.total*100).to_i.to_s, 'operation_number' => operation.number, 'order_number' => order.number,
                    'first_name' => params[:first_name],
                    'last_name' => params[:last_name],
                    'email'=>params[:email],
                    'address'=>params[:address],
                    'zip'=>params[:zip],
                    'city'=>params[:city],
                    'state'=>params[:state],
                    'country'=>params[:country],
                    'method_id'=>params[:method_id],
                    'phone'=>params[:phone]}.to_json
    response = http.request(request)

    @req = ActiveSupport::JSON.decode(response.body)
    Rails.logger.debug @req.inspect
  end

  def payment
    @order = Spree::Order.find(params[:id])
    @user = spree_current_user
    @address = @user.billing_address
    @method_id = params[:method_id]
  end

  def callback
    uri = URI.parse("http://127.0.0.1:8888")
    http = Net::HTTP.new(uri.host, uri.port)
    decode_request = Net::HTTP::Post.new("/decode")
    decode_request.body = request.body.read
    response = http.request(decode_request)
    @data = ActiveSupport::JSON.decode(response.body)
    Rails.logger.debug @data.inspect
    if (@data['auth_result'].to_i == 1)
      redirect_to '/checkout/payment', :alert => "Operacion denegada"
    elsif @data['auth_result'].to_i == 5
      redirect_to '/checkout/payment', :alert => "Operacion rechazada"
    elsif @data['auth_result'].to_i == 0
        @order = Spree::Order.find_by_number(@data['order_number'])
        auth = Spree::CreditCardAuth.new
        auth.order = @order
        auth.amount = @data['total'].to_i
        auth.auth_code = @data['auth_code']
        auth.save!
        @payment_method = @data['method_id']
    else
      redirect_to '/checkout/payment', :alert => "Operacion invalida"
    end
  end
end