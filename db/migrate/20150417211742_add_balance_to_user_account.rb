class AddBalanceToUserAccount < ActiveRecord::Migration
  def change
    add_column :spree_user_accounts, :balance, :decimal, :null => false, :default => 0
  end
end
