class ScootersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate

  def update
    scooter = Scooter.find(params[:id])
    factory = RGeo::Cartesian.factory
    scooter.update!(
      location: factory.point(params[:longitude], params[:latitude]),
      battery_level: params[:battery_level])
    head :ok
  end

  def validate
    [:id, :latitude, :longitude, :battery_level].each do |p|
      params.require(p)
    end
  end
end
