class Spree::CreditCardAuth < ActiveRecord::Base
  belongs_to :order, class_name: 'Spree::Order'
end
