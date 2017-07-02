class CreateFilmLists < ActiveRecord::Migration[5.0]
  def change
    create_table :film_lists do |t|
      t.string :image
      t.string :status
      t.string :title_vi
      t.string :title_en
      t.string :duration
      t.string :url

      t.timestamps
    end
  end
end
