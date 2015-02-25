require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get how_it_works" do
    get :how_it_works
    assert_response :success
  end

  test "should get how_to_be_a_host" do
    get :how_to_be_a_host
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
