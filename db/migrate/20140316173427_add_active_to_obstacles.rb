class AddActiveToObstacles < ActiveRecord::Migration
  def change
    add_column :obstacles, :active, :boolean, default: true
  end
end
