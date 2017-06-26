require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get inventario" do
    get static_pages_inventario_url
    assert_response :success
  end

  test "should get store" do
    get static_pages_store_url
    assert_response :success
  end

end
