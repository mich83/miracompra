class AddHighDemandToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :high_demand, :boolean, {:null => false, :default => false}
  end
end
