class AddDeletedAtToSpreeProductTranslations < ActiveRecord::Migration
  def change
    add_column :spree_product_translations, :deleted_at, :datetime
  end
end
