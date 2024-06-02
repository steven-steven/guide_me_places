class PrimaryController < ApplicationController
  def index
    @locations = GoogleSheetReader.call("Places to visit")
  end

  def place_details
    @location = params["location"]
    @iframe1 = params["iframe1"]

    respond_to do |format|
      format.turbo_stream
    end
  end
end
