class CreateAccountsForExistingUsers < ActiveRecord::Migration
  def change
    Spree::User.find_each do |user|
      user.create_accounts
    end
  end
end
