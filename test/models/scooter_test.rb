require 'test_helper'

class ScooterTest < ActiveSupport::TestCase
  test "screate" do
    factory = RGeo::Cartesian.factory
    scooter = Scooter.new location: factory.point(0,0), battery_level: 0.5, inactive: false
    assert scooter.valid?
    scooter.save
  end
end
