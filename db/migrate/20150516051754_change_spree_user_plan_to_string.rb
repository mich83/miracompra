class ChangeSpreeUserPlanToString < ActiveRecord::Migration
  def change
    change_column :spree_users, :plan, :string
  end
end
