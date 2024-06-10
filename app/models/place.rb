class Place < ApplicationRecord
  def self.to_json
    all.map do |place|
      {
        id: place.id,
        name: place.name,
        lat: place.lat,
        long: place.long,
        emoji: place.emoji,
      }
    end.to_json
  end
end