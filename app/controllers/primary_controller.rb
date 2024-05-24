class PrimaryController < ApplicationController
  def index
    @locations = GoogleSheetReader.call("Places to visit")
  end
end
