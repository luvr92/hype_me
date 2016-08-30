require 'open-uri'
require 'nokogiri'

event =

html_file = open("https://www.residentadvisor.net/events.aspx?ai=13&v=month&mn=8&yr=2016&dy=29")
html_doc = Nokogiri::HTML(html_file)

# html_doc.search('.bbox').each do |element|
#   puts element.text
# end

id_s = []

html_doc.search('.bbox').each do |link|

  id = link.at("h1 a[href]")
  id_s << id
end

p id_s
