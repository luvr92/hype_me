require 'open-uri'
require 'nokogiri'

class ResidentAdvisorDjParser
  def initialize(url)
    @url = url
    @dj = {}  # Not an Event model!
  end

  def parse
    @doc = Nokogiri::HTML(open(@url))
    parse_sc_username
  end

  private

  def parse_sc_username
    soundcloud_div = @doc.css("#SoundcloudPlaceholder").first
    if soundcloud_div
      @dj[:sc_username] = soundcloud_div.attributes['data-soundcloud-username'].text
    else
      @dj[:sc_username] = nil
    end
  end
end

# parser = ResidentAdvisorDjParser.new("https://www.residentadvisor.net/event.aspx?866342")
# parser = ResidentAdvisorDjParser.new("https://www.residentadvisor.net/dj/applebottom")
# https://www.residentadvisor.net/dj/applebottom
