require 'open-uri'
require 'nokogiri'

class ResidentAdvisorEventParser
  def initialize(url)
    @url = url
    @event = {}  # Not an Event model!
  end

  # Return details about the Event (not creating anything in the DB or touching it)
  def parse
    @doc = Nokogiri::HTML(open(@url))
    parse_details
    parse_flyer
    parse_line_up
    parse_description
    parse_sc_username

    return @event
  end

  private

  def parse_details
    @doc.search("#detail").each do |info|
      hours = info.at("ul li").text.to_s # OPENING AND CLOSING HOURS
      hours = hours.scan(/(\d\d\D\d\d\s\D\s\d\d\D\d\d)/)
      @event[:hours] = hours.flatten.join

      venue = info.at("ul li:nth-child(2) a.cat-rev") # VENUE NAME
      if venue == nil
        @event[:venue_name] = info.at("ul li:nth-child(2)").children.select { |child| child.is_a?(Nokogiri::XML::Text) }.first.text.to_s
      else
        @event[:venue_name] = venue.text
      end

      venue_address = info.at("ul li:nth-child(2)").children.select { |child| child.is_a?(Nokogiri::XML::Text) }.first
      @event[:venue_address] = venue_address.content.strip if venue_address

      @event[:price] = info.at("ul li:nth-child(3)").text.gsub("/", " ") # PRICE
    end
  end

  def parse_flyer
    @doc.search(".flyer").each do |info|
      event_flyer = info.at("a img[src]") # .values[0]
      if event_flyer
        @event[:flyer] = "https://www.residentadvisor.net" + event_flyer.values[0]
      end
    end
  end

  def parse_line_up
    @doc.search("#event-item").each do |info|
      @event[:line_up] << info.at("div:nth-child(3) p").text.to_s.gsub("\r\n", ",").split(",")
    end
  end

  def parse_description
    @doc.search(".left").each do |info|
      event_description = info.at("p:nth-child(3)").text.to_s
      event_description.gsub!("\n",'')
      event_description.gsub!("\r",'')
      event_description.gsub!("\t",'')
      @event[:description] = event_description.strip
    end
  end

  def parse_sc_username
    dj_names = []

    dj_names = @doc.css('div.left a').map { |link| link['href'] }
    dj_names = dj_names[0...-1]

    dj_names.map do |dj|
      dj.gsub!("/dj/",'')
    end

    @event[:line_up_soundcloud] = []
    dj_names.map do |dj_name|
      url = "https://www.residentadvisor.net/dj/#{dj_name}"
      parser = ResidentAdvisorDjParser.new(url)
      @event[:line_up_soundcloud] << parser.parse
    end
  end
end
