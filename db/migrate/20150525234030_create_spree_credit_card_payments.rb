class CreateSpreeCreditCardPayments < ActiveRecord::Migration
  def change
    create_table :spree_credit_card_payments do |t|
      t.string :number
      t.integer :value
      t.references :spree_order, index: true

      t.timestamps null: false
    end
    add_foreign_key :spree_credit_card_payments, :spree_orders
  end
end
