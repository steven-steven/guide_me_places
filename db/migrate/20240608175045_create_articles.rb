class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :url
      t.string :image
      t.string :title
      t.string :favicon
      t.text :short_description
      t.json :places, default: []

      t.timestamps
    end
  end
end
