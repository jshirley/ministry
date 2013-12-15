class CreateFieldValues < ActiveRecord::Migration
  def change
    create_table :field_values do |t|
      t.references :project, index: true
      t.references :field, index: true
      t.references :user, index: true
      t.text :value

      t.timestamps
    end
  end
end
