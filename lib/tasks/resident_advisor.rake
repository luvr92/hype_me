require 'open-uri'
require 'nokogiri'
require 'time'
require 'pry-byebug'


namespace :resident_advisor do
  task list: :environment do
    # TODO: list all the ra ids
    current_year = Date.today.year
    current_month = Date.today.month
    current_day = Date.today.day

    html_file = open("https://www.residentadvisor.net/events.aspx?ai=13&v=day&mn=#{current_month}&yr=#{current_year}&dy=#{current_day}")
    html_doc = Nokogiri::HTML(html_file)

    # SCRAPING THE DAILY EVENTS' IDS

    id_s = []

    html_doc.search('.bbox').each do |link|
      id = link.at("h1 a[href]").to_s
      id_s << id.scan(/(\d\d\d\d\d\d)/)
    end

    id_s.delete_if do |id|
      id.empty?
    end

    id_s.flatten!
    p id_s
  end

  task :import, [:resident_advisor_id] => :environment do |t, args|
    resident_advisor_id = args[:resident_advisor_id]

    #TODO
    #
    #
    # Save the event to the database
    # Event.create...

    html_event = open("https://www.residentadvisor.net/event.aspx?#{resident_advisor_id}")
    event_html = Nokogiri::HTML(html_event)

    event_attributes = {}

    # SCRAPING FOR DATE , START AND END TIME , VENUE NAME , VENUE ADDRESS

    info = event_html.search("#detail").first

    # date = info.at("ul li a[href]").text.to_s #DATE

    hours = info.at("ul li").text.to_s # OPENING AND CLOSING HOURS
    hours = hours.scan(/(\d\d\D\d\d\s\D\s\d\d\D\d\d)/)
    hours.flatten!
    hours = hours.join("")
    hours = hours.split(" - ")
    starts = hours[0]
    starts = DateTime.parse(starts)
    ends = hours[1]
    ends = DateTime.parse(ends)

    venue = info.at("ul li:nth-child(2) a.cat-rev") # VENUE NAME
    if venue == nil
      venue = info.at("ul li:nth-child(2)").children.select { |child| child.is_a?(Nokogiri::XML::Text) }.first.text.to_s
    else
      venue = venue.text.to_s
    end

    # VENUE ADDRESS
    venue_address_element = info.at("ul li:nth-child(2)").children.select { |child| child.is_a?(Nokogiri::XML::Text) }.first
    if venue_address_element
      venue_address = venue_address_element.content.strip
    end

    price = info.at("ul li:nth-child(3)").text.to_s # PRICE
    price = price.gsub("/", " ")



    # p venue
    # p starts
    # p ends
    # p date
    # p venue_address
    # p price


    # SCRAPING FOR EVENT'S TITLE

    info = event_html.search("#sectionHead").first
    event_title = info.at("h1").text.to_s

    # SCRAPING FOR EVENT'S LINE-UP

    info = event_html.search("#event-item").first
    event_line_up = info.at("div:nth-child(3) p").text.to_s
    event_line_up = event_line_up.gsub("\r\n", ",").split(",")
      #p event_line_up


    # SCRAPING FOR EVENT'S DESCRIPTION

    info = event_html.search(".left").first
    event_description = info.at("p:nth-child(3)").text.to_s
    event_description.gsub!("\n",'')
    event_description.gsub!("\r",'')
    event_description.gsub!("\t",'')
    event_description = event_description.strip
      #p event_description
    club = Club.create(name: venue, address: venue_address)
    # binding.pry
    evento = Event.new(title: event_title, club: club, price: price, starts_at: starts, ends_at: ends, address: venue_address, description: event_description)
    evento.save
  end
end
