class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.text :description
      t.integer :next_status_id

      t.timestamps
    end
  end
end
