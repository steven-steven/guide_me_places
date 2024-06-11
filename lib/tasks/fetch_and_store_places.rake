namespace :data do
  desc "Fetch data from API, delete existing records, and store in the table. rails data:fetch_and_store"
  task fetch_and_store_places: :environment do
    require 'net/http'
    require 'json'

    Place.delete_all

    GoogleSheetReader.call(:call).each do |item|
      identifier = AirtableReader.call(:get_place_id, place_name: item[:place])
      Place.create(
        name: item[:place],
        identifier:,
        lat: item[:lat],
        long: item[:long],
        emoji: item[:emoji],
        iframes: [item[:iframe1], item[:iframe2], item[:iframe3]].compact_blank!
      )
    end

    puts "Data fetched, existing records deleted, and new data stored in the table."
  end
end
