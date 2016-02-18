class DynamicRouter
  def self.load
    Rails.application.routes.draw do
      begin
        Spree::CustomPage.all.each do |pg|
          get "/#{pg.route}", :to => "spree/custom_pages#show", defaults: { id: pg.id }
        end
      rescue
      end
    end
  end

  def self.reload
    Rails.application.routes_reloader.reload!
  end
end