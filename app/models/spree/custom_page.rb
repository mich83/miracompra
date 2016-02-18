class Spree::CustomPage < ActiveRecord::Base
  before_save :check_route
  after_save :reload_routes

  def check_route
    if valid_variable_name?(self.route)
      return true
    else
      @errors.add :route, :invalid_route
      return false
    end
  end

  def valid_variable_name?(s)
    begin
      Object.new.instance_variable_set ("@"+s).intern, nil
      return true
    rescue NameError
      return false
    end
  end

  def reload_routes
    DynamicRouter.reload
  end
end
