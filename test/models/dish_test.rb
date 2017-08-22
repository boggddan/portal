require 'test_helper'

class DishTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  test "should not save dish without name" do
    dish = Dish.new
    assert_not dish.save, "Saved the dish without a dishes_category_id"
  end


  test "should report error" do
    # переменная some_undefined_variable не определена в тесте
    assert_raises(NameError) do
      some_undefined_variable
    end
  end
end

