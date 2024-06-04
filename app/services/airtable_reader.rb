require 'google_drive'

class AirtableReader < ApplicationService
  def initialize(table: "Articles", place_name: nil)
    @place_name = place_name
    @client = Airtable::Client.new(Rails.application.credentials.airtable_api_key)
    @table = @client.table("appWX3ubnFwIVgs2t", table)
  end

  def get_articles
    @table.all()
  end

  def get_place_id
    @table.select(formula: "Name = '#{@place_name}'").first[:id]
  end
end
