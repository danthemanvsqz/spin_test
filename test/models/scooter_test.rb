require 'test_helper'

class ScooterTest < ActiveSupport::TestCase
  setup do
    @factory = RGeo::Cartesian.factory
  end

  test "create" do
    scooter = Scooter.new(location: @factory.point(0,0), battery_level: 0.5, inactive: false)
    assert scooter.valid?
    scooter.save
  end

  test "it is invalid when invalid param" do
    assert_raises(ActiveRecord::RecordInvalid) do
      Scooter.create!(location: @factory.point(0,0), battery_level: -0.5, inactive: false) 
    end
  end
end
