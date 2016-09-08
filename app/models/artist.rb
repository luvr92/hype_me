class Artist < ApplicationRecord
  def soundcloud_widget
    client = Soundcloud.new(:client_id => ENV["SOUND_CLOUD_CLIENT_app_id"])
    track_url = "https://soundcloud.com/#{soundcloud_username}"
    embed_info = client.get('/oembed', :url => track_url)
    embed_info['html']
  end
end
