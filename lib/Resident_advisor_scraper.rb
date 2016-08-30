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

p id_s
