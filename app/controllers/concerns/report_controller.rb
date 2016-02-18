class Concerns::ReportController < Spree::BaseController
  before_action :authenticate_spree_user!
  def show
    preferred_server = Spree::Config.report_server
    preferred_infobase = Spree::Config.report_infobase
    url = URI("#{preferred_server}/#{preferred_infobase}/hs/reports/generate")
    req = Net::HTTP::Post.new(url)
    req_params = Hash.new
    req_params["token"] = Spree::Config.report_token
    req_params["report"] = params[:name]
    req_params["settings"] = Hash.new
    params.each_key do |key|
      if !(key == "name" || key == "controller" || key == "action" || key=~/_type$/)
        if params[key+"_type"].nil?
          req_params["settings"][key.to_s] = params[key]
        else
          req_params["settings"][key.to_s] = {ref_type: params[key+"_type"], id: params[key]}
        end
      end
    end
    req.body = req_params.to_json
    req.basic_auth Spree::Config.report_user, Spree::Config.report_password
    resp = Net::HTTP.start(url.hostname, url.port, :use_ssl => url.scheme == 'https') do |http|
      http.request(req)
    end
    expires_now
    render :content_type => 'text/html', :body => resp.body.gsub(/body {.*}/, "").gsub(/table {/,"div#externalDialog > table {")
  end
end