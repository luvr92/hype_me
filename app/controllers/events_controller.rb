require 'soundcloud'

class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @events = Event.near([params[:lat], params[:lng]], 50).where(date: Date.today).first(10)
    @user_lat = params[:lat]
    @user_lng = params[:lng]
    # @event = @events.first
    # redirect_to event_path(@event)
  end

  def show
    # @event = Event.find(params[:id])
    # @hash = [{:lat=>@event.latitude, :lng=>@event.longitude}]
    # @hash = Gmaps4rails.build_markers([ @event ]) do |event, marker|
    #   marker.lat event.latitude
    #   marker.lng event.longitude
    #   # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    # end

    # create a client object with your app credentials
    # client = Soundcloud.new(:client_id => ENV["SOUND_CLOUD_CLIENT_app_id"])

    # get a tracks oembed data
    # track_url = @profile.soundcloud_link
    # track_url = "https://soundcloud.com/garzygoesdeep/ride-on-time-club-edit"
    # embed_info = client.get('/oembed', :url => track_url)

    # print the html for the player widget
    # @url_embed = embed_info['html']

  end

  private

  def event_params
    params.require(:event).permit(:title, :club_id, :price, :address, :starts_at, :ends_at, :description, :opening_hours, :date, :event_url)
  end
end
