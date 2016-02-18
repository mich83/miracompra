Spree::ProductsController.class_eval do
    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      @links = header_links
    end

    def show
      if params[:ref].present?
        session[:referral] = params[:ref]
        Rails.logger.debug "REFERRAL ASSIGNED #{session[:referral]}"
      end
      @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
      @product_properties = @product.product_properties.includes(:property)
      @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
    end

    def header_links
      [{:url => '/', :name => 'Hogar' }, {:url => '/company', :name=>'Moda'}, {:url => '/my_orders', :name=>"Tecnología"}]
    end

end
