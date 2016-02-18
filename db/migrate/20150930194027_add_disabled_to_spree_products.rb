class AddDisabledToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :disabled, :boolean, :null => false, :default => false
  end
end
