require 'google_drive'

class AirtableReader < ApplicationService
  def initialize
    @client = Airtable::Client.new(Rails.application.credentials.airtable_api_key)
    @articles_table = @client.table("appWX3ubnFwIVgs2t", "Articles")
    @places_table = @client.table("appWX3ubnFwIVgs2t", "Places")
  end

  def get_articles
    @articles_table.all()
  end

  def get_place_id(place_name:)
    @places_table.select(formula: "Name = '#{@place_name}'").first[:id]
  end

  def get_unprocessed_article_urls
    @articles_table.select(formula: "AND(NOT({Image}), NOT({Favicon}), NOT({Short Description}))")
  end

  def update_articles_record(article_record:)
    @articles_table.update(article_record)
  end
end
