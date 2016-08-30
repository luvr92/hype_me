require 'open-uri'
require 'nokogiri'


current_year = Date.today.year
# p current_year
current_month = Date.today.month
# p current_month
current_day = Date.today.day
# p current_day

html_file = open("https://www.residentadvisor.net/events.aspx?ai=13&v=month&mn=#{current_month}&yr=#{current_year}&dy=#{current_day}")
html_doc = Nokogiri::HTML(html_file)

# html_doc.search('.bbox').each do |element|
#   puts element.text
# end

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



# id_s.each do |event_id|
html_event = open("https://www.residentadvisor.net/event.aspx?862446")
event_html = Nokogiri::HTML(html_event)
event_attributes = {}
event_html.search("#detail").each do |info|
  date = info.at("ul li a[href]").text.to_s

  hours = info.at("ul li").text.to_s
  hours = hours.scan(/(\d\d\D\d\d\s\D\s\d\d\D\d\d)/)
  hours.flatten!
  hours = hours.join("")

  venue = info.at("ul li:nth-child(2) a[href]").text.to_s

  venue_address_element = info.at("ul li:nth-child(2)").children.select { |child| child.is_a?(Nokogiri::XML::Text) }.first
  if venue_address_element
    venue_address = venue_address_element.content.strip
  end

  p venue
  p hours
  p date
  p venue_address

end


