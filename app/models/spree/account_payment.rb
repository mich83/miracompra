class Spree::AccountPayment < ActiveRecord::Base
  belongs_to :spree_user_account, :class_name => 'Spree::UserAccount'
end
