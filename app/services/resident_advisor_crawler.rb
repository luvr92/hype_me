require 'open-uri'
require 'nokogiri'

class ResidentAdvisorCrawler
  def initialize(city_id, date)
    @city_id = city_id
    @date = date
  end

  # Return an array of event URLs
  def crawl
    event_ids = []

    url = "https://www.residentadvisor.net/events.aspx?ai=#{@city_id}&v=day&mn=#{@date.month}&yr=#{@date.year}&dy=#{@date.day}"
    doc = Nokogiri::HTML(open(url))
    doc.search('.bbox').each do |link|
      event_id = link.at("h1 a[href]").to_s.scan(/(\d\d\d\d\d\d)/).flatten.first
      event_ids << event_id unless event_id.blank?
    end

    event_ids.map do |event_id|
      "https://www.residentadvisor.net/event.aspx?#{event_id}"
    end
  end
end
