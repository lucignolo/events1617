require 'test_helper'

class LpublishersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lpublisher = lpublishers(:one)
  end

  test "should get index" do
    get lpublishers_url
    assert_response :success
  end

  test "should get new" do
    get new_lpublisher_url
    assert_response :success
  end

  test "should create lpublisher" do
    assert_difference('Lpublisher.count') do
      post lpublishers_url, params: { lpublisher: { ID_EDITORE: @lpublisher.ID_EDITORE, Nome: @lpublisher.Nome } }
    end

    assert_redirected_to lpublisher_url(Lpublisher.last)
  end

  test "should show lpublisher" do
    get lpublisher_url(@lpublisher)
    assert_response :success
  end

  test "should get edit" do
    get edit_lpublisher_url(@lpublisher)
    assert_response :success
  end

  test "should update lpublisher" do
    patch lpublisher_url(@lpublisher), params: { lpublisher: { ID_EDITORE: @lpublisher.ID_EDITORE, Nome: @lpublisher.Nome } }
    assert_redirected_to lpublisher_url(@lpublisher)
  end

  test "should destroy lpublisher" do
    assert_difference('Lpublisher.count', -1) do
      delete lpublisher_url(@lpublisher)
    end

    assert_redirected_to lpublishers_url
  end
end
