module Spree
  module Admin
    class InvitationsController < ResourceController
      def index
        @invitations = Spree::Invitation.page(params[:page] || 1).per(50)
      end
    end
  end
end