Spree::Core::ProductFilters.module_eval do
  def self.price_filter
    v = Spree::Price.arel_table
    conds = [ [ Spree.t(:under_price, price: format_price(20))     , v[:amount].lteq(20)],
              [ "#{format_price(20)} - #{format_price(50)}"        , v[:amount].in(20..50)],
              [ "#{format_price(50)} - #{format_price(100)}"        , v[:amount].in(50..100)],
              [ "#{format_price(100)} - #{format_price(250)}"        , v[:amount].in(100..250)],
              [ Spree.t(:or_over_price, price: format_price(250)) , v[:amount].gteq(250)]]
    {
        name:   Spree.t(:price_range),
        scope:  :price_range_any,
        conds:  Hash[*conds.flatten],
        labels: conds.map { |k,v| [k, k] }
    }
  end

end