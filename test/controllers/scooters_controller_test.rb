require 'test_helper'

class ScootersControllerTest < ActionDispatch::IntegrationTest
  setup do
    factory = RGeo::Cartesian.factory
    @scooter = Scooter.find_or_create_by(location: factory.point(0,0), battery_level: 0, inactive: false)
  end

  test "should put update" do
    put "/scooters/#{@scooter.id}/update", params: {latitude: 5, longitude: 5, battery_level: 0.4}
    assert_response :success
    @scooter.reload
    assert_in_delta(@scooter.battery_level, 0.4, 0.0001)
  end

  test "should put deactivate" do
    put "/scooters/#{@scooter.id}/deactivate"
    assert_response :success
    @scooter.reload
    assert @scooter.inactive
  end 

  test "should post activate" do
    @scooter.update!(inactive: true)
    post "/scooters/activate", params: {ids: [@scooter.id]}
    assert_response :success
    @scooter.reload
    assert_not @scooter.inactive
  end

  test "post activate should roll back when not found" do
    @scooter.update!(inactive: true)
    assert_raises(ActiveRecord::RecordNotFound) do
      post "/scooters/activate", params: {ids: [@scooter.id, 2]}
    end
    @scooter.reload
    assert @scooter.inactive
  end

end
