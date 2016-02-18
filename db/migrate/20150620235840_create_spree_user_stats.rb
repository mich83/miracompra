class CreateSpreeUserStats < ActiveRecord::Migration
  def change
    create_table :spree_user_stats do |t|
      t.references :spree_user
      t.decimal :comisiones, :default => 0
      t.decimal :bono, :default => 0
      t.decimal :comercializacion, :default => 0
      t.decimal :c_limite, :default => 0
      t.decimal :esp_recompra, :default => 0
      t.decimal :esp_factura, :default => 0
      t.decimal :acreditado, :default => 0

      t.timestamps null: false
    end
  end
end
