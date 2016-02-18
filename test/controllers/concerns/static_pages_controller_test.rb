require 'test_helper'

class Concerns::StaticPagesControllerTest < ActionController::TestCase
  test "should get catalog" do
    get :catalog
    assert_response :success
  end

end
