class CreatePredefinedCodes < ActiveRecord::Migration
  def change
    create_table :predefined_codes do |t|
      t.string :code
      t.boolean :assigned

      t.timestamps null: false
    end
  end
end
