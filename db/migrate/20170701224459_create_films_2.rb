class CreateFilms2 < ActiveRecord::Migration[5.0]
  def change
    create_table :films do |t|
      t.string :f_title_vi
      t.string :f_title_en
      t.string :f_image
      t.string :f_imdb
      t.string :f_status
      t.string :f_country
      t.string :f_score
      t.string :f_views
      t.string :f_year
      t.string :f_trailer
      t.string :f_see_film
      t.text :f_content
      t.integer :film_list_id

      t.timestamps
    end
  end
end
