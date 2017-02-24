require 'test_helper'

class InstitutionOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @institution_order = institution_orders(:one)
  end

  test "should get index" do
    get institution_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_institution_order_url
    assert_response :success
  end

  test "should create institution_order" do
    assert_difference('InstitutionOrder.count') do
      post institution_orders_url, params: { institution_order: { date_end: @institution_order.date_end, date_sa: @institution_order.date_sa, date_start: @institution_order.date_start, institution_id: @institution_order.institution_id } }
    end

    assert_redirected_to institution_order_url(InstitutionOrder.last)
  end

  test "should show institution_order" do
    get institution_order_url(@institution_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_institution_order_url(@institution_order)
    assert_response :success
  end

  test "should update institution_order" do
    patch institution_order_url(@institution_order), params: { institution_order: { date_end: @institution_order.date_end, date_sa: @institution_order.date_sa, date_start: @institution_order.date_start, institution_id: @institution_order.institution_id } }
    assert_redirected_to institution_order_url(@institution_order)
  end

  test "should destroy institution_order" do
    assert_difference('InstitutionOrder.count', -1) do
      delete institution_order_url(@institution_order)
    end

    assert_redirected_to institution_orders_url
  end
end
