Spree::Product.class_eval do
  # Can't use add_search_scope for this as it needs a default argument
  def self.available(available_on = nil, currency = nil)
    joins(:master => :prices).where("#{Spree::Product.quoted_table_name}.available_on <= ? and disabled = ?", available_on || Time.now, false)
  end


end