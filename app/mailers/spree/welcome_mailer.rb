module Spree
  class WelcomeMailer < ActionMailer::Base
    def from_address
      Spree::Store.current.mail_from_address
    end
    def image_name(image)
      File.join(Rails.root, 'app', 'assets', 'images', image)
    end
    def attach_image(name)
      attachments.inline[name] = File.read(image_name(name), mode: 'rb')
    end
    def welcome(user)
      attach_image('logo.png')
      attach_image('header.png')
      @user = user
      @ref = Spree::Referral.where(:user_id => user.id).first
      mail(to: user.email, from: from_address, subject: Spree.t(:welcome_to_miracompra))
    end

    def notify(user, parent_user)
      attach_image('logo.png')
      @new_user = user
      @ref = Spree::Referral.where(:user_id => user.id).first
      @parent_user = parent_user
      mail(to: @parent_user.email, from: from_address, subject: Spree.t(:new_referal_registered))
    end
  end
end