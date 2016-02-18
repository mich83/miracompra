Spree::User.class_eval do
  validates :full_name, presence: true
  validates :document, presence: true
  validates :phone, presence: true
  validates_each :referral_code do |record, attr, value|
    record.errors.add(attr, " está incorrecto!") if !value.blank? && Spree::Referral.find_by_code(value).nil?
  end
  validates :referral_code, presence: true, :on => :create
  belongs_to :bill_addr, foreign_key: :bill_address_id, class_name: 'Spree::Address'
  belongs_to :ship_addr, foreign_key: :ship_address_id, class_name: 'Spree::Address'
  has_many :spree_user_accounts, :class_name => 'Spree::UserAccount'

  accepts_nested_attributes_for :ship_address
  accepts_nested_attributes_for :bill_address

  before_save :check_class
  after_create :before_address
  after_create :create_accounts
  after_create :notify_all
  before_create :generate_key

  def referred_by_id
    referred_by.id unless referred_by.nil?
  end
  def generate_key
    self.spree_api_key = SecureRandom.hex(24)
  end

  def bill_address
    self.bill_addr ||= Spree::Address.build_default
    self.bill_addr
  end

  def use_billing=(use)
    if use
      self.ship_addr = self.bill_addr
    end
  end

  def bill_address=(ref)
    self.bill_addr = ref
  end
  def ship_address
    self.ship_addr ||= Spree::Address.build_default
    self.ship_addr
  end

  def ship_address=(ref)
    self.ship_addr = ref
  end

  def before_address
    self.bill_addr ||= Spree::Address.build_default
    self.ship_addr ||= Spree::Address.build_default
  end

  def check_class
    Rails.logger.debug "Check class"
    Rails.logger.debug self.bill_addr.inspect
  end

  def display_name
    if self.full_name.nil? || self.full_name.empty?
      self.email
    else
      "#{self.full_name} (#{self.email})"
    end
  end

  def ref_code
    session[:referral]
  end

  def notify_all
    Spree::WelcomeMailer.welcome(self).deliver_now

    if self.referred?
      parent_user = self.referred_by
    #parents = Spree::BaseHelper.run_tree_query("b=#{id} and a <> #{id}")
    #parents.each do |parent|
    #    Rails.logger.debug parent.inspect
    #    parent_user = Spree::User.find(parent['parent'])
    #    Rails.logger.debug parent_user.inspect
        msg = Spree::WelcomeMailer.notify(self,parent_user)
        msg.deliver_now
    end
  end

  def balance(account_type)
    account = Spree::UserAccount.where(spree_user_id: self.id, account_type: account_type).first
    if account.nil?
      0
    else
      account.balance
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (conditions[:email].match /^MC\d{6,}$/).nil?
      where(conditions.to_h).first
    else
      ref = Spree::Referral.find_by_code(conditions[:email])
      if ref.nil?
        nil
      else
        find(ref.user_id)
      end
    end
  end

  def accounts
    Spree::UserAccount.where(spree_user_id: self.id)
  end

  def create_accounts
    current_account = Spree::UserAccount.new
    current_account.spree_user = self
    current_account.account_type = :current
    current_account.save!

    invest_account = Spree::UserAccount.new
    invest_account.spree_user = self
    invest_account.account_type = :invest
    invest_account.save!

    #avail_account = Spree::UserAccount.new
    #avail_account.spree_user = self
    #avail_account.account_type = :available
    #avail_account.save!
  end

  def bill_and_ship_address_equal?
    (bill_address.empty? && ship_address.empty?) || bill_address.same_as?(ship_address)
  end
end

Spree::Address.class_eval do
  has_many :user
end

Spree::UsersController.class_eval do
  def user_params
    params.require(:user).permit(:email, :full_name, :document, :password, :password_confirmation, :birth_date, :phone, :mobile, bill_address_attributes: [:firstname, :lastname, :address1, :address2, :city, :country_id, :state_id, :zipcode, :phone, :parroquia ], ship_address_attributes: [:firstname, :lastname, :parroquia, :address1, :address2, :city, :country_id, :state_id, :zipcode, :phone ])
  end
end