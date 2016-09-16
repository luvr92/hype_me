require 'open-uri'
require 'nokogiri'
require 'time'
# require 'pry-byebug'

namespace :resident_advisor do
  task import_today: :environment do
    cities = [1, 2, 8, 13, 14, 15, 16, 20, 23, 24, 25, 27, 29, 30, 34, 35, 38, 43, 44, 60, 62, 174, 175, 176, 177, 178, 218]
    cities.each do |city_id|
      ImportEventsJob.new(city_id, Date.today).perform_now
    end
  end
end

# Includes: UK, NL

    # + Top 20 regions
# London, UK /
# Berlin, DE /
# Amsterdam, NL /
# Paris, FR /
# New York, US /
# Tokyo, JP /
# Barcelona, ES /
# Switzerland /
# Manchester, UK /
# Los Angeles, US /
# South + East, UK /
# Ibiza, ES /
# Miami, US /
# West + Wales, UK /
# Glasgow, UK /
# San Francisco, US /
# Belgium /
# Ireland /
# Sydney, AU /
# Melbourne, AU /
