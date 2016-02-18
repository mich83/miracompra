class Spree::Discount < ActiveRecord::Base
  belongs_to :spree_taxon, :class => "Spree::Taxon"

  def self.get_discount(product)
    max_discount = 0
    if product.class == Spree::Variant
      product = product.product
    end
    product.taxons.each do |t|
      current_discount = discount(t)
      max_discount =  current_discount if current_discount > max_discount
      t.ancestors.each do |a|
        current_discount = discount(a)
        max_discount =  current_discount if current_discount > max_discount
      end
    end
    max_discount
  end

  def self.discount(taxon)
    discount = Spree::Discount.where(:spree_taxon_id => taxon.id).first
    discount.nil? ? 0 : discount.value
  end

end
