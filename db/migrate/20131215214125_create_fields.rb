class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.text :description
      t.text :placeholder
      t.string :type
      t.boolean :required
      t.integer :row_order

      t.timestamps
    end
  end
end
