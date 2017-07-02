class CreateFilms < ActiveRecord::Migration[5.0]
  def change
    create_table :films do |t|
      t.string :f_title_vi
      t.string :f_title_en
      t.string :f_image
      t.string :f_imdb
      t.string :f_status
      t.string :f_country
      t.string :f_quality
      t.string :f_resolution
      t.string :f_year

      t.timestamps
    end
  end
end
