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

end
