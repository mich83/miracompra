class AddAvailableAccount < ActiveRecord::Migration
  def up
    users = Spree::User.all
    users.each { |user|
      if Spree::UserAccount.where(:account_type => :available, :spree_user_id => user.id).first.nil?
        avail_account = Spree::UserAccount.new
        avail_account.spree_user = user
        avail_account.account_type = :available
        avail_account.save!
      end
    }
  end
  def down

  end
end
