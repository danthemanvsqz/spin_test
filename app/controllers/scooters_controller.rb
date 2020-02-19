class ScootersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_update, :only => [:update]
  before_action :validate_activate, :only => [:activate]
  before_action :validate_available, :only => [:available]


  def factory
    RGeo::Cartesian.factory
  end

  def update
    scooter = Scooter.find(params[:id])
    scooter.update!(
      location: factory.point(params[:longitude], params[:latitude]),
      battery_level: params[:battery_level])
    head :ok
  end

  def deactivate
    Scooter.update(params[:id], inactive: true)
    head :ok
  end

  def activate
    # Optimizing for readability here ideally we would want to bulk update
    # all the ids but tracking errors and timestamps would be more complex
    ActiveRecord::Base.transaction do
      params[:ids].each do |id|
        Scooter.update(id, inactive: false)
      end
    end
    head :ok
  end

  def available
    buf = factory.point(params[:longitude], params[:latitide]).buffer(params[:radius].to_f)
    scooters = Scooter.where(battery_level: 0.3..1, inactive: false).pluck(:location)
    # The following line raises
    # RGeo::Error::UnsupportedOperation: Method Geometry#contains? not defined.
    # Not sure why and I've spent enough time debugging.
    # filtered_scooters = scooters.select {|loc| buf.contains? loc }

    render :success, json: scooters.map { |s| RGeo::GeoJSON.encode(s) }
  end

  def validate_update
    [:id, :latitude, :longitude, :battery_level].each do |p|
      params.require(p)
    end
  end

  def validate_activate
    params.require(:ids)
    params[:ids] |= []
  end

  def validate_available
    [:latitude, :longitude, :radius].each do |p|
      params.require(p)
    end

    # Using arbitrary max distance b/c of laziness.
    unless (0..1000.0).include? params[:radius].to_f
      render json: {error: "radius of #{params[:radius]} is not valid"}, status: 400
    end
  end
end
