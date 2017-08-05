require 'test_helper'

class LbooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lbook = lbooks(:one)
  end

  test "should get index" do
    get lbooks_url
    assert_response :success
  end

  test "should get new" do
    get new_lbook_url
    assert_response :success
  end

  test "should create lbook" do
    assert_difference('Lbook.count') do
      post lbooks_url, params: { lbook: { c01_vecchioid: @lbook.c01_vecchioid, c02_titolo: @lbook.c02_titolo, c03_prezzoeurodec: @lbook.c03_prezzoeurodec, c04_EDIZIONE: @lbook.c04_EDIZIONE, c05_IDDISTRIBUTORE: @lbook.c05_IDDISTRIBUTORE, c06_IDSERIE: @lbook.c06_IDSERIE, c07_ISBN: @lbook.c07_ISBN, c08_copie: @lbook.c08_copie, c09_deposito: @lbook.c09_deposito, c10_publisher_id: @lbook.c10_publisher_id, c11_IDTIPOOPERA: @lbook.c11_IDTIPOOPERA, c12_ANNOEDIZIONE: @lbook.c12_ANNOEDIZIONE, c13_note: @lbook.c13_note, c14_idaliquotaiva: @lbook.c14_idaliquotaiva, c15_url2: @lbook.c15_url2 } }
    end

    assert_redirected_to lbook_url(Lbook.last)
  end

  test "should show lbook" do
    get lbook_url(@lbook)
    assert_response :success
  end

  test "should get edit" do
    get edit_lbook_url(@lbook)
    assert_response :success
  end

  test "should update lbook" do
    patch lbook_url(@lbook), params: { lbook: { c01_vecchioid: @lbook.c01_vecchioid, c02_titolo: @lbook.c02_titolo, c03_prezzoeurodec: @lbook.c03_prezzoeurodec, c04_EDIZIONE: @lbook.c04_EDIZIONE, c05_IDDISTRIBUTORE: @lbook.c05_IDDISTRIBUTORE, c06_IDSERIE: @lbook.c06_IDSERIE, c07_ISBN: @lbook.c07_ISBN, c08_copie: @lbook.c08_copie, c09_deposito: @lbook.c09_deposito, c10_publisher_id: @lbook.c10_publisher_id, c11_IDTIPOOPERA: @lbook.c11_IDTIPOOPERA, c12_ANNOEDIZIONE: @lbook.c12_ANNOEDIZIONE, c13_note: @lbook.c13_note, c14_idaliquotaiva: @lbook.c14_idaliquotaiva, c15_url2: @lbook.c15_url2 } }
    assert_redirected_to lbook_url(@lbook)
  end

  test "should destroy lbook" do
    assert_difference('Lbook.count', -1) do
      delete lbook_url(@lbook)
    end

    assert_redirected_to lbooks_url
  end
end
