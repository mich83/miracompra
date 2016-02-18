class CreateSpreeDiscounts < ActiveRecord::Migration
  def change
    create_table :spree_discounts do |t|
      t.string :name
      t.integer :value
      t.references :spree_taxon, index: true

      t.timestamps null: false
    end
    add_foreign_key :spree_discounts, :spree_taxons
  end
end
