module Spree
  module Api
    class ReferalsController < Spree::Api::BaseController
      def get_subordinates

        @subordinates = Array.new
        if check_subordinate(params[:id].to_i)
            user = Spree::User.find(params[:id])
            user.referral.referred_users.each do |ref|
              @subordinates << {
                  id: ref.id,
                  name: ref.display_name,
                  has_children: ref.referral.referred_users.count != 0,
                  parent_id: params[:id],
                  plan_presentation: ref.plan_presentation,
                  plan: ref.plan.nil? ? "" : ref.plan,
                  plan_image: ActionController::Base.helpers.image_url(ref.plan_image),
                  full_name: ref.full_name,
                  phone: ref.phone,
                  code: ref.referral.code,
                  email: ref.email,
                  city: ref.ship_address.nil? ? "" : ref.ship_address.city,
                  parent: ref.referred? ? ref.referred_by.display_name : ""

              }
            end
        end
        respond_with @subordinates
      end

      private

      def check_subordinate(id)
        if id == current_api_user.id || current_api_user.admin?
          return true
        end
        Spree::BaseHelper.run_tree_query("a=#{current_api_user.id} and b=#{id}").count !=0
      end
    end
  end
end