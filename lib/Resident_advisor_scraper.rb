# THIS FILE IS NO LONGER BEING USED, REFACTORED IN SERVICES AND JOBS

require 'open-uri'
require 'nokogiri'
require 'time'
require 'pry'


cities = [13, 20, 34, 44] # London, Barcelona, Berlin, Paris

cities.each do |city|
  current_year = Date.today.year
  current_month = Date.today.month
  current_day = Date.today.day

  html_file = open("https://www.residentadvisor.net/events.aspx?ai=#{city}&v=day&mn=#{current_month}&yr=#{current_year}&dy=#{current_day}")
  html_doc = Nokogiri::HTML(html_file)

#   # SCRAPING THE DAILY EVENTS' IDS

  id_s = []

  html_doc.search('.bbox').each do |link|

    id = link.at("h1 a[href]").to_s
    # id.gsub(/\D/, "")
    id_s << id.scan(/(\d\d\d\d\d\d)/)
    # p id
  end
  id_s.delete_if do |id|
    id.empty?
  end

  id_s.flatten!

  # SCRAPING FOR EACH EVENT'S ATTRIBUTES

  id_s.each do |event_id|
    html_event = open("https://www.residentadvisor.net/event.aspx?#{event_id}")
    event_html = Nokogiri::HTML(html_event)

#     # SCRAPING FOR DATE , START AND END TIME , VENUE NAME , VENUE ADDRESS

#     event_html.search("#detail").each do |info|

#       # date = info.at("ul li a[href]").text.to_s #DATE

#       hours = info.at("ul li").text.to_s # OPENING AND CLOSING HOURS
#       hours = hours.scan(/(\d\d\D\d\d\s\D\s\d\d\D\d\d)/)
#       hours.flatten!
#       hours = hours.join("")


#       venue = info.at("ul li:nth-child(2) a.cat-rev") # VENUE NAME
#       if venue == nil
#         venue = info.at("ul li:nth-child(2)").children.select { |child| child.is_a?(Nokogiri::XML::Text) }.first.text.to_s
#       else
#         venue = venue.text.to_s
#       end

#       # VENUE ADDRESS
#       venue_address_element = info.at("ul li:nth-child(2)").children.select { |child| child.is_a?(Nokogiri::XML::Text) }.first
#       if venue_address_element
#         venue_address = venue_address_element.content.strip
#       end

#       price = info.at("ul li:nth-child(3)").text.to_s # PRICE
#       price = price.gsub("/", " ")



#       p venue
#       p hours
#       # p date
#       p venue_address
#       p price

#     end


#     event_html.search(".flyer").each do |info|
#       event_flyer = info.at("a img[src]") # .values[0]
#       if event_flyer
#         event_flyer = event_flyer.values[0]
#         event_flyer = "https://www.residentadvisor.net" + event_flyer
#       end
#       # p event_flyer
#     end

#     # SCRAPING FOR EVENT'S TITLE

#     event_html.search("#sectionHead").each do |info|
#       event_title = info.at("h1").text.to_s
#       p event_title
#     end

#     # SCRAPING FOR EVENT'S LINE-UP

#     event_html.search("#event-item").each do |info|
#       event_line_up = info.at("div:nth-child(3) p").text.to_s
#       event_line_up = event_line_up.gsub("\r\n", ",").split(",")
#       p event_line_up
#     end

#     # SCRAPING FOR EVENT'S DESCRIPTION

#     event_html.search(".left").each do |info|
#       event_description = info.at("p:nth-child(3)").text.to_s
#       event_description.gsub!("\n",'')
#       event_description.gsub!("\r",'')
#       event_description.gsub!("\t",'')
#       event_description = event_description.strip
#       p event_description
#     end

    # SCRAPING FOR SOUNDCLOUD DJ URL'S
    dj_names = []


    dj_names = event_html.css('div.left a').map { |link| link['href'] }
    dj_names = dj_names[0...-1]

    # ENTERING DJ RA PAGE

    dj_names.each do |dj_url|
      url = "https://www.residentadvisor.net#{dj_url}"
      dj_html = Nokogiri::HTML(open(url))

      soundcloud_div = dj_html.css("#SoundcloudPlaceholder").first
      if soundcloud_div
        soundcloud_username = soundcloud_div.attributes['data-soundcloud-username'].text
        puts soundcloud_username + " for " + url
      else
        puts "No soundcloud usename at #{url}"
      end
    end
  end
end
