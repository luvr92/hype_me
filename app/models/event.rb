class Event < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :club
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
