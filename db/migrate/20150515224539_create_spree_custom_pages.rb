class CreateSpreeCustomPages < ActiveRecord::Migration
  def change
    create_table :spree_custom_pages do |t|
      t.text :name
      t.text :content

      t.timestamps null: false
    end
  end
end
