class Rename2Columns < ActiveRecord::Migration[5.0]
  def change
  	rename_column :films, :f_quality, :f_score
  	rename_column :films, :f_resolution, :f_views
  end
end
