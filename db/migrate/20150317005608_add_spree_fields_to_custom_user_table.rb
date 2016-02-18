class AddSpreeFieldsToCustomUserTable < ActiveRecord::Migration
  def up
    #add_column "spree_users", :spree_api_key, :string, :limit => 48
    #add_column "spree_users", :ship_address_id, :integer
    #add_column "spree_users", :bill_address_id, :integer

    add_column "spree_users", :full_name, :string
    add_column "spree_users", :document, :string
    add_column "spree_users", :birth_date, :date
    add_column "spree_users", :login_name, :string
    add_column "spree_users", :phone, :string
    add_column "spree_users", :mobile, :string
    add_column "spree_users", :plan, :integer
  end
end
