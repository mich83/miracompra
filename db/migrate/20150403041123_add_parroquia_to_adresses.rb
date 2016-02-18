class AddParroquiaToAdresses < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :parroquia, :string
  end
end
