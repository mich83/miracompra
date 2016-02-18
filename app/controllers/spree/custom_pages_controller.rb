module Spree
  class CustomPagesController < Spree::BaseController
    def show
      @page = CustomPage.find(params[:id])
    end
  end
end