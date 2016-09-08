class ImportEventsJob < ApplicationJob
  def perform(city_id, date)
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil


    puts "Importing events for city #{city_id}..."
    crawler = ResidentAdvisorCrawler.new(city_id, date)
    urls = crawler.crawl
    puts "Found #{urls.count} events..."

    urls.each do |url|
      print "Scraping #{url}..."

      parser = ResidentAdvisorEventParser.new(url)
      event_info = parser.parse

      print ", importing #{event_info[:title]}..."

      event = Event.find_by(title: event_info[:title]) || Event.new

      if event.persisted?
        print ", updating existing event..."
      else
        print ", 🆕 ..."
      end

      club = Club.find_by(name: event_info[:venue_name]) || Club.new(name: event_info[:venue_name])
      club.address = event_info[:venue_address]
      event.club = club

      event.title = event_info[:title]
      event.opening_hours = event_info[:hours]
      event.address = event_info[:venue_address]
      event.price = event_info[:price]
      event.remote_photo_url = event_info[:flyer]
      event.description = event_info[:description]
      event.event_url = url
      event.date = event_info[:event_date]
      # TODO: Line-up saved as EventArtist
      event_info[:line_up].each do |line_up_artist|
        artist = Artist.find_by(name: line_up_artist[:name]) || Artist.new(name: line_up_artist[:name])
        artist.soundcloud_username = line_up_artist[:soundcloud]
        artist.save
        event.event_artists.build(artist_id: artist.id)
      end

      if event.save
        puts " Imported."
      else
        puts " ERROR!!!!"
        puts event.errors.full_messages
      end
    end
  ensure
    ActiveRecord::Base.logger = old_logger
  end
end
