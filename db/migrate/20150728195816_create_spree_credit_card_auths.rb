class CreateSpreeCreditCardAuths < ActiveRecord::Migration
  def change
    create_table :spree_credit_card_auths do |t|
      t.references :order
      t.integer :amount
      t.string :auth_code

      t.timestamps null: false
    end
  end
end
