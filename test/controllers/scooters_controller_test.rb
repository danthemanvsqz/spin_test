require 'test_helper'

class ScootersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @factory = RGeo::Cartesian.factory
    @scooter = Scooter.find_or_create_by(location: @factory.point(0,0), battery_level: 0.5, inactive: false)
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

  test "get available scooters" do
    spin_hq = @factory.point(-122.39867, 37.784)
    museum = @factory.point(122.40117, 37.785587)
    @scooter.update!(location: museum)
    battery_low = Scooter.create!(location: museum, battery_level: 0.1, inactive: false)
    inactive = Scooter.create!(location: museum, battery_level: 0.9, inactive: true)
    get "/scooters/available", params: {latitude: spin_hq.y, longitude: spin_hq.x, radius: spin_hq.distance(museum) + 1} 
    assert_response :success
    results = JSON.parse(response.body)
    assert results.size == 1
  end

end
