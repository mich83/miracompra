class Spree::CreditCardPayment < ActiveRecord::Base
  belongs_to :spree_order
  after_create :update_number

  def update_number
    self.number = self.id+50
#    n = ""
#    while id_shifted >= 36
#      digit = id_shifted % 36
#      id_shifted = id_shifted / 36
#      if digit<10
#         n = digit.to_s + n
#      else
#         n = (digit+55).chr + n
#      end
#    end
#    if id_shifted < 10
#      n = id_shifted.to_s + n
#    else
#      n = (id_shifted+55).chr + n
#    end

#    self.number = n
    self.save!
  end
end
