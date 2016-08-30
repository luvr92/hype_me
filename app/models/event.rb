class Event < ApplicationRecord
  belongs_to :club
  geocoded_by :address
  after_validation :address, if: :address_changed?
end
