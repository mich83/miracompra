class CreateSpreeInvitations < ActiveRecord::Migration
  def self.up
    create_table :spree_invitations do |t|
      t.string :name
      t.text :message
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :spree_invitations
  end
end