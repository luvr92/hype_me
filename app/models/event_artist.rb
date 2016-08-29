class EventArtist < ApplicationRecord
  belongs_to :event
  belongs_to :artist
end
