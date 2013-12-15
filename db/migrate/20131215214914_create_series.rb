class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.references :user, index: true
      t.string :name
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
