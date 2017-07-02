class DropFilms < ActiveRecord::Migration[5.0]
  def change
  	drop_table :films
  end
end
