namespace :data do
  desc "Fetch data from API, delete existing records, and store in the table. rails data:fetch_and_store"
  task fetch_and_store_articles: :environment do
    require 'net/http'
    require 'json'

    Article.delete_all

    AirtableReader.call(:get_articles).each do |item|
      Article.create(
        url: item[:url],
        image: item[:image],
        title: item[:title],
        favicon: item[:favicon],
        short_description: item[:short_description],
        places: item[:places]
      )
    end

    puts "Data fetched, existing records deleted, and new data stored in the table."
  end
end
