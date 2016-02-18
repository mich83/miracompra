Spree::Core::Search::Base.class_eval do
  def get_base_scope
    base_scope = Spree::Product.active.real
    if !keywords.nil?
      variants = Spree::Variant.where(:sku => keywords.strip)
      if variants.any?
        products_id = variants.map {|v| v.product_id}
        return base_scope.where(:id=> products_id)
      end
    end
    base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
    base_scope = get_products_conditions_for(base_scope, keywords)
    base_scope = add_search_scopes(base_scope)
    base_scope = add_eagerload_scopes(base_scope)
    base_scope
  end

end