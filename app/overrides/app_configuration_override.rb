Spree::AppConfiguration.class_eval do
  preference :report_server, :string
  preference :report_infobase, :string
  preference :report_token, :string
  preference :report_user, :string
  preference :report_password, :password
end