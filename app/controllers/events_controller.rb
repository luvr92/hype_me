class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index

  end

  def show
    @event = Event.find(params[:id])

    @hash = Gmaps4rails.build_markers([ @event ]) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude
      # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :club_id, :price, :address, :starts_at, :ends_at, :description)
  end
end
