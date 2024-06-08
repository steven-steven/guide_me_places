class PrimaryController < ApplicationController
  def index
    @locations = Rails.cache.fetch('cached_places') do
      GoogleSheetReader.call(:call, sheet: "Places to visit")
    end
  end

  def world_view
    respond_to do |format|
      format.turbo_stream
    end
  end

  def place_details
    @location = params["location"]
    @iframe1 = params["iframe1"]

    location_id = Rails.cache.fetch("cached_id_for#{params["location"].underscore}") do
      AirtableReader.call(:get_place_id, table: "Places", place_name: @location)
    end
    airtable = Rails.cache.fetch('cached_articles') do
      AirtableReader.call(:get_articles)
    end
    @articles = airtable.select{|record| record[:places].include?(location_id)}
    # @articles = [
    #   {url: "https://murexresorts.com/bunaken-island-an-underwater-paradise-with-diverse-marine-life/", title: "Bunaken Island: An Underwater Paradise with Diverse Marine Life", short_description: "Are you dreaming about diving the Bunaken Island with us while staying at Murex Manado? Get in touch and email your enquiry now!", image: "https://murexresorts.com/wp-content/uploads/2023/07/Turtle-in-sponge-2-scaled.jpg", favicon: "https://murexresorts.com/wp-content/uploads/2021/09/cropped-Shell-Outline_CoralGradient_square-32x32.png"},
    #   {url: "https://murexresorts.com/bunaken-island-an-underwater-paradise-with-diverse-marine-life/", title: "Bunaken Island: An Underwater Paradise with Diverse Marine Life", short_description: "Are you dreaming about diving the Bunaken Island with us while staying at Murex Manado? Get in touch and email your enquiry now!", image: "https://murexresorts.com/wp-content/uploads/2023/07/Turtle-in-sponge-2-scaled.jpg", favicon: "https://murexresorts.com/wp-content/uploads/2021/09/cropped-Shell-Outline_CoralGradient_square-32x32.png"},
    # ]

    respond_to do |format|
      format.turbo_stream
    end
  end
end
