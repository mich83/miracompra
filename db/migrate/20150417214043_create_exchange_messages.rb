class CreateExchangeMessages < ActiveRecord::Migration
  def change
    create_table :exchange_messages do |t|
      t.boolean :confirmed
      t.datetime :date_time

      t.timestamps null: false
    end
  end
end
