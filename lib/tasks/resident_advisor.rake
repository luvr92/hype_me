require 'open-uri'
require 'nokogiri'
require 'time'
# require 'pry-byebug'

namespace :resident_advisor do
  task import_today: :environment do
    cities = [13, 20, 34, 44]
    cities.each do |city_id|
      ImportEventsJob.new(city_id, Date.today).perform_now
    end
  end
end
