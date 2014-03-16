class CreateObstacles < ActiveRecord::Migration
  def change
    create_table :obstacles do |t|
      t.references :project, index: true
      t.references :user, index: true

      t.text :description
      t.text :strategy
      t.text :results

      t.integer :flag, default: 0, null: false

      t.integer :row_order, default: 0

      t.timestamps
    end
  end
end
