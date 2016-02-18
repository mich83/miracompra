object @user

attributes *user_attributes
child(:bill_address => :bill_address) do
  extends "spree/api/addresses/show"
end

child(:ship_address => :ship_address) do
  extends "spree/api/addresses/show"
end

node (:referral_id) {|user| user.referred_by.id unless user.referred_by.nil?}

node (:referred_users) {|user| user.referral.referred_users.map {|u| u.id unless u.nil? }}