class CreateSeriesProjects < ActiveRecord::Migration
  def change
    create_table :series_projects do |t|
      t.references :series, index: true
      t.references :project, index: true
      t.integer :row_order

      t.timestamps
    end
  end
end
