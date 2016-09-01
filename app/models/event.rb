class Event < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :club
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  has_many :event_artists
  has_many :artists, through: :event_artists
end

# artist = Artist.find?
# artist = Artist.new
# event.event_artists.build(artist: artist)
# event.save
