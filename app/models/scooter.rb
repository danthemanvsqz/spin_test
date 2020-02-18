class Scooter < ApplicationRecord
  validates :location, presence: true
  validates :battery_level, presence: true
  validate :check_battery_level, on: [:save, :create, :update] 

  def check_battery_level
    unless (0..100).include? battery_level
      errors.add(:battery_level, "battery_level must be between 0 and 100")
    end
  end
end
