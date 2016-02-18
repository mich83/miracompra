class DeleteAvailAccounts < ActiveRecord::Migration
  def change
    Spree::UserAccount.where(account_type: :available).destroy_all
  end
end
