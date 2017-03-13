require 'test_helper'

class SetdefaultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setdefault = setdefaults(:one)
  end

  test "should get index" do
    get setdefaults_url
    assert_response :success
  end

  test "should get new" do
    get new_setdefault_url
    assert_response :success
  end

  test "should create setdefault" do
    assert_difference('Setdefault.count') do
      post setdefaults_url, params: { setdefault: { chef: @setdefault.chef, runner: @setdefault.runner, user_id: @setdefault.user_id } }
    end

    assert_redirected_to setdefault_url(Setdefault.last)
  end

  test "should show setdefault" do
    get setdefault_url(@setdefault)
    assert_response :success
  end

  test "should get edit" do
    get edit_setdefault_url(@setdefault)
    assert_response :success
  end

  test "should update setdefault" do
    patch setdefault_url(@setdefault), params: { setdefault: { chef: @setdefault.chef, runner: @setdefault.runner, user_id: @setdefault.user_id } }
    assert_redirected_to setdefault_url(@setdefault)
  end

  test "should destroy setdefault" do
    assert_difference('Setdefault.count', -1) do
      delete setdefault_url(@setdefault)
    end

    assert_redirected_to setdefaults_url
  end
end
