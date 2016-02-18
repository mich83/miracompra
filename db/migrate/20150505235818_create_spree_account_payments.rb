class CreateSpreeAccountPayments < ActiveRecord::Migration
  def change
    create_table :spree_account_payments do |t|
      t.references :user_account
      t.string :document_ref
      t.decimal :value
      t.string :reason

      t.timestamps null: false
    end
  end
end
