class CreateSpreeUserAccounts < ActiveRecord::Migration
  def change
    create_table :spree_user_accounts do |t|
      t.belongs_to :spree_user, index: true
      t.string :account_type
      t.timestamps null: false
    end
  end
end
