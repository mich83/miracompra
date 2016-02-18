Spree::FrontendHelper.class_eval do
  def flash_messages(opts = {})
    ignore_types = ["order_completed"].concat(Array(opts[:ignore_types]).map(&:to_s) || [])

    dismiss_button = '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
    flash.each do |msg_type, text|
      unless ignore_types.include?(msg_type)
        concat(content_tag :div, dismiss_button.html_safe + text, class: "alert alert-dismissible fade in alert-#{msg_type}")
      end
    end
    nil
  end

  def users_show_navbar
    {:links => [{:url => '/account', :name => 'Mi cuenta' }, {:url => '/company', :name=>'Mi organización'}, {:url => '/my_orders', :name=>"Mis pedidos"}], :shopping_cart => false}
  end

  def products_navbar
    #links = nav_taxons(nil)
    return {:links => nil, :shopping_cart => true}
  end

  def nav_taxons(parent_id)
    taxons = Spree::Taxon.where(:parent_id => parent_id)
    if !taxons.any?
      parent_id = Spree::Taxon.find(parent_id).parent.id
      taxons = Spree::Taxon.where(:parent_id => parent_id)
    end
    taxons = taxons.select {|t| has_products(t)}
    Rails.logger.debug taxons.inspect
    taxons.map { |t| {:url => seo_url(t), :name => t.name, :ref => t} }.sort_by {|f| f[:name].tr('áéíóúüñÁÉÍÓÚÜÑ','aeiouunAEIOUUN')}
  end

  def has_products(taxon)
    if taxon.products.available.count != 0
      return true
    end
    taxons = Spree::Taxon.where(:parent_id => taxon.id)
    taxons.each do |t|
      if has_products(t)
        return true
      end
    end
    false
  end

  def taxons_navbar
    products_navbar
  end

  def navbar_data(controller, action)
    if respond_to?("#{controller}_#{action}_navbar".to_sym)
      return send("#{controller}_#{action}_navbar".to_sym)
    elsif self.respond_to?("#{controller}_navbar".to_sym)
      return send("#{controller}_navbar".to_sym)
    else
      return nil
    end
  end

  def price_with_discount(product, currency)
      full_price = product.price_in(currency).price
      if spree_current_user.nil? || spree_current_user.plan.blank?
        result = full_price
      else
        result = full_price*(1-Spree::Discount.get_discount(product).to_f/100)
      end
      default_opts = { currency: currency }
      Spree::Money.new(result, default_opts).to_html
  end


end