class ChangeTypeFieldInFilmList < ActiveRecord::Migration[5.0]
  def change
  	rename_column :film_lists, :type, :film_type
  end
end
