class EventsController < ApplicationController
  def show
    @flats = Event.where.not(latitude: nil, longitude: nil)

    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude
      # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end
end
