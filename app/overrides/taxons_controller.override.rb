Spree::TaxonsController.class_eval do
    def show
      @taxon = Spree::Taxon.friendly.find(params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      @links = header_links
    end
    def header_links
      [{:url => '/', :name => 'Hogar' }, {:url => '/company', :name=>'Moda'}, {:url => '/my_orders', :name=>"Tecnología"}]
    end

end
