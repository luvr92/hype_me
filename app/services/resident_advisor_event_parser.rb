require 'open-uri'
require 'nokogiri'
require 'time'

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
    parse_title
    parse_line_up
    parse_description

    return @event
  end

  private

  def parse_details
    @doc.search("#detail").each do |info|
      hours = info.at("ul li").text.to_s # OPENING AND CLOSING HOURS
      hours = hours.scan(/(\d\d\D\d\d\s\D\s\d\d\D\d\d)/)
      @event[:hours] = hours.flatten.join


      date = info.at("ul li a[href]").text.to_s
      @event[:event_date] = Date.strptime(date, "%d %B %Y")

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
      @event_flyer = info.at("a img[src]") # .values[0]
      if @event_flyer
        @event[:flyer] = "https://www.residentadvisor.net" + @event_flyer.values[0]
      end
    end
  end

  def parse_title
    @doc.search("#sectionHead").each do |info|
      @event[:title] = info.at("h1").text.to_s
    end
  end

  def parse_line_up
    @event[:line_up] = []
    @doc.css('.lineup').first.children.reject { |c| c.name == 'br' || c.content.strip.blank? }.each do |node|
      if node.name == "a"  # Link to DJ profile
        dj_name = node.content.strip
        dj_parser = ResidentAdvisorDjParser.new(node.attributes["href"].value)
        soundcloud_username = dj_parser.parse
      else
        dj_name = node.content.strip
        soundcloud_username = nil
      end

      @event[:line_up] << {
        name: dj_name,
        soundcloud: soundcloud_username
      }
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
end
