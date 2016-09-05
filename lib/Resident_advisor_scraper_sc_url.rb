require 'open-uri'
require 'nokogiri'



# SCRAPING FOR SOUNDCLOUD URL


html_file = open("https://www.residentadvisor.net/events.aspx?ai=13&v=day&mn=9&yr=#2016&dy=5")
html_doc = Nokogiri::HTML(html_file)

dj_names = []

html_doc.search('.bbox').each do |link|

  id = link.at("h1 a[href]").to_s
    # id.gsub(/\D/, "")
    id_s << id.scan(/(\d\d\d\d\d\d)/)
    # p id
  end
  id_s.delete_if do |id|
    id.empty?
  end


  dj_names.each do |dj_name|
    html_event = open("https://www.residentadvisor.net/event.aspx?#{dj_name}")
    event_html = Nokogiri::HTML(html_event)
  end


