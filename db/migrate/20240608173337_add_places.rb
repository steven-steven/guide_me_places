class AddPlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :places do |t|
      t.string :name
      t.string :identifier
      t.string :lat
      t.string :long
      t.string :emoji
      t.json :iframes, default: []

      t.timestamps
    end
  end
end
