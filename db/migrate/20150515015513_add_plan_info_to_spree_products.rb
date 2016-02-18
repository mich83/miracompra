class AddPlanInfoToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :plan_info, :string
  end
end
