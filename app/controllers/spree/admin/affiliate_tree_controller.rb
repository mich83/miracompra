module Spree
  module Admin
    class AffiliateTreeController < ResourceController
      def index
        @users = Spree::User.find_by_sql("SELECT * FROM spree_users where not id in (select user_id from spree_referred_records) ")
      end

      def model_class
        Spree::ReferredRecord
      end
    end
  end
end