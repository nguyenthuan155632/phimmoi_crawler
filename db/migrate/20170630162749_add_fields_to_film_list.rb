class AddFieldsToFilmList < ActiveRecord::Migration[5.0]
  def change
  	add_column :film_lists, :type, :string
  	add_column :film_lists, :full_type, :string
  end
end
