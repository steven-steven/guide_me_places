require 'google_drive'

class GoogleSheetReader < ApplicationService
  def initialize(sheet)
    @sheet = sheet
    @session = GoogleDrive::Session.from_service_account_key("./config/google_drive_service_api_key.json")
  end

  def call
    spreadsheet = @session.spreadsheet_by_title(@sheet)
    worksheet = spreadsheet.worksheets.first
    worksheet.rows[1..].map do |location|
      {
        place: location[0],
        lat: location[1].to_f,
        long: location[2].to_f,
        emoji: location[3],
        iframe1: location[4],
        iframe2: location[5],
        iframe3: location[6],
      }
    end
  end
end