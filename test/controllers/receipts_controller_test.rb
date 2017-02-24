require 'test_helper'

class ReceiptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receipt = receipts(:one)
  end

  test "should get index" do
    get receipts_url
    assert_response :success
  end

  test "should get new" do
    get new_receipt_url
    assert_response :success
  end

  test "should create receipt" do
    assert_difference('Receipt.count') do
      post receipts_url, params: { receipt: { contract_number: @receipt.contract_number, date: @receipt.date, date_sa: @receipt.date_sa, institution_id: @receipt.institution_id, invoice_number: @receipt.invoice_number, supplier_order_id: @receipt.supplier_order_id } }
    end

    assert_redirected_to receipt_url(Receipt.last)
  end

  test "should show receipt" do
    get receipt_url(@receipt)
    assert_response :success
  end

  test "should get edit" do
    get edit_receipt_url(@receipt)
    assert_response :success
  end

  test "should update receipt" do
    patch receipt_url(@receipt), params: { receipt: { contract_number: @receipt.contract_number, date: @receipt.date, date_sa: @receipt.date_sa, institution_id: @receipt.institution_id, invoice_number: @receipt.invoice_number, supplier_order_id: @receipt.supplier_order_id } }
    assert_redirected_to receipt_url(@receipt)
  end

  test "should destroy receipt" do
    assert_difference('Receipt.count', -1) do
      delete receipt_url(@receipt)
    end

    assert_redirected_to receipts_url
  end
end
