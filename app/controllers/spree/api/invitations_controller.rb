require 'erb'
module Spree
  module Api
    class InvitationsController < Spree::Api::BaseController
      require 'mailgun'
      def show
        @invitation = Spree::Invitation.find(params[:id])
        respond_with @invitation
      end

      def send_invite
        set_content_type
        load_user
        authenticate_user
        load_user_roles

        msg = {
            :to => params[:email],
            :subject => params[:subject],
            :from => Spree::Store.current.mail_from_address,
            :html => params[:msg].gsub(/#ref/, referral_url(@current_api_user.referral.code)).gsub(/#nombre/, params[:name])
        }

        mg_client = Mailgun::Client.new "key-c02109080ddf7ac8e6a7607bb153bc1b"
        mg_client.send_message "miracompra.com.ec", msg
        @result  = {status: "OK"}
        respond_with @result
      end
    end

    class MessageBuilder
      include ActionView::Helpers::UrlHelper
      def name
        @name
      end
      def ref_link
        @ref_link
      end

      def initialize(name, ref_link, template)
        @name = name
        @ref_link = ref_link
        @tmpl = ERB.new template
      end

      def result
        @tmpl.result(binding)
      end
    end
  end
end