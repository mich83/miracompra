module Spree
  module Admin
    class CustomPagesController < ResourceController
      def index
        @custom_pages = CustomPage.all
      end
    end
  end
end
