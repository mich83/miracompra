class AddRouteToSpreeCustomPage < ActiveRecord::Migration
  def change
    add_column :spree_custom_pages, :route, :string
  end
end
