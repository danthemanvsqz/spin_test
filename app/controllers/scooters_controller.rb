class ScootersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_update, :only => [:update]
  before_action :validate_activate, :only => [:activate]

  def update
    scooter = Scooter.find(params[:id])
    factory = RGeo::Cartesian.factory
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

  def validate_update
    [:id, :latitude, :longitude, :battery_level].each do |p|
      params.require(p)
    end
  end

  def validate_activate
    params.require(:ids)
    params[:ids] |= []
  end
end
