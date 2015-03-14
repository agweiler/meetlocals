require 'test_helper'

class ExperiencesControllerTest < ActionController::TestCase
  setup do
    @experience = experiences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:experiences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create experience" do
    assert_difference('Experience.count') do
      post :create, experience: { available_days: @experience.available_days, cuisine: @experience.cuisine, description: @experience.description, duration: @experience.duration, host_id: @experience.host_id, host_style: @experience.host_style, is_halal: @experience.is_halal, max_group_size: @experience.max_group_size, price: @experience.price, title: @experience.title }
    end

    assert_redirected_to experience_path(assigns(:experience))
  end

  test "should show experience" do
    get :show, id: @experience
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @experience
    assert_response :success
  end

  test "should update experience" do
    patch :update, id: @experience, experience: { available_days: @experience.available_days, cuisine: @experience.cuisine, description: @experience.description, duration: @experience.duration, host_id: @experience.host_id, host_style: @experience.host_style, is_halal: @experience.is_halal, max_group_size: @experience.max_group_size, price: @experience.price, title: @experience.title }
    assert_redirected_to experience_path(assigns(:experience))
  end

  test "should destroy experience" do
    assert_difference('Experience.count', -1) do
      delete :destroy, id: @experience
    end

    assert_redirected_to experiences_path
  end
end
