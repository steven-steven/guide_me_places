class PrimaryController < ApplicationController
  def index
  end

  def world_view
    @place = Place.find(params["id"])

    respond_to do |format|
      format.turbo_stream
    end
  end

  def place_details
    @place = Place.find(params["id"])

    @articles = Article.where("places LIKE ?", "%#{@place.identifier}%")
    # @articles = [
    #   {url: "https://murexresorts.com/bunaken-island-an-underwater-paradise-with-diverse-marine-life/", title: "Bunaken Island: An Underwater Paradise with Diverse Marine Life", short_description: "Are you dreaming about diving the Bunaken Island with us while staying at Murex Manado? Get in touch and email your enquiry now!", image: "https://murexresorts.com/wp-content/uploads/2023/07/Turtle-in-sponge-2-scaled.jpg", favicon: "https://murexresorts.com/wp-content/uploads/2021/09/cropped-Shell-Outline_CoralGradient_square-32x32.png"},
    #   {url: "https://murexresorts.com/bunaken-island-an-underwater-paradise-with-diverse-marine-life/", title: "Bunaken Island: An Underwater Paradise with Diverse Marine Life", short_description: "Are you dreaming about diving the Bunaken Island with us while staying at Murex Manado? Get in touch and email your enquiry now!", image: "https://murexresorts.com/wp-content/uploads/2023/07/Turtle-in-sponge-2-scaled.jpg", favicon: "https://murexresorts.com/wp-content/uploads/2021/09/cropped-Shell-Outline_CoralGradient_square-32x32.png"},
    #   {url: "https://murexresorts.com/bunaken-island-an-underwater-paradise-with-diverse-marine-life/", title: "Bunaken Island: An Underwater Paradise with Diverse Marine Life"},
    # ]

    respond_to do |format|
      format.turbo_stream
    end
  end

  def map
    @locations_json = Place.to_json
  end
end
