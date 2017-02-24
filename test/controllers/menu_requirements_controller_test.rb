require 'test_helper'

class MenuRequirementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @menu_requirement = menu_requirements(:one)
  end

  test "should get index" do
    get menu_requirements_url
    assert_response :success
  end

  test "should get new" do
    get new_menu_requirement_url
    assert_response :success
  end

  test "should create menu_requirement" do
    assert_difference('MenuRequirement.count') do
      post menu_requirements_url, params: { menu_requirement: { branch_id: @menu_requirement.branch_id, date: @menu_requirement.date, date_saf: @menu_requirement.date_saf, date_sap: @menu_requirement.date_sap, institution_id: @menu_requirement.institution_id, number: @menu_requirement.number, splendingdate: @menu_requirement.splendingdate } }
    end

    assert_redirected_to menu_requirement_url(MenuRequirement.last)
  end

  test "should show menu_requirement" do
    get menu_requirement_url(@menu_requirement)
    assert_response :success
  end

  test "should get edit" do
    get edit_menu_requirement_url(@menu_requirement)
    assert_response :success
  end

  test "should update menu_requirement" do
    patch menu_requirement_url(@menu_requirement), params: { menu_requirement: { branch_id: @menu_requirement.branch_id, date: @menu_requirement.date, date_saf: @menu_requirement.date_saf, date_sap: @menu_requirement.date_sap, institution_id: @menu_requirement.institution_id, number: @menu_requirement.number, splendingdate: @menu_requirement.splendingdate } }
    assert_redirected_to menu_requirement_url(@menu_requirement)
  end

  test "should destroy menu_requirement" do
    assert_difference('MenuRequirement.count', -1) do
      delete menu_requirement_url(@menu_requirement)
    end

    assert_redirected_to menu_requirements_url
  end
end
