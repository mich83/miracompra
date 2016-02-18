class UserMc < Spree::User
  validates :full_name, presence: true
  before_save :check_write

  def check_write
    Rails.logger.debug self.inspect
  end
end