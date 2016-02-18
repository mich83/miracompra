module Spree
  module Admin
    class DiscountsController < ResourceController
      def index
        @discounts = Discount.all
      end
    end
  end
end
