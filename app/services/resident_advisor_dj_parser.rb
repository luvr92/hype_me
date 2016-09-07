require 'open-uri'
require 'nokogiri'

class ResidentAdvisorDjParser
  def initialize(path)
    @url = "https://www.residentadvisor.net#{path}"
    @dj = {}  # Not an Event model!
  end

  def parse
    @doc = Nokogiri::HTML(open(@url))
    soundcloud_div = @doc.css("#SoundcloudPlaceholder").first
    if soundcloud_div
      soundcloud_div.attributes['data-soundcloud-username'].text
    else
      nil
    end
  end
end
