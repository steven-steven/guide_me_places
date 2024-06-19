namespace :data do
  desc "Fetch unprocessed article URLs, query Diffbot, and update Airtable records"
  task enhance_articles: :environment do
    require 'net/http'
    require 'json'
    require 'uri'

    AirtableReader.call(:get_unprocessed_article_urls).each do |item|
      puts item
      uri = URI("https://api.diffbot.com/v3/analyze?token=#{Rails.application.credentials.diffbot_token}&url=#{URI.encode_www_form_component(item[:url])}")

      response = Net::HTTP.get(uri)
      details = JSON.parse(response)
      next if details.blank? || details["errorCode"] == 500

      item[:Image] = details.dig("objects", 0, "images", 0, "url")
      item[:Favicon] = details.dig("objects", 0, "icon")
      # item["Short Description"] = (details.dig("objects", 0, "text") || details.dig("objects", 0, "description"))&.split(/(?<=[.!?])\s+|\n+/)&.slice(2,2)&.join(" ")
      AirtableReader.call(:update_articles_record, article_record: item)
    end

    puts "Articles has been processed"
  end
end
