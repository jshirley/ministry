class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :project, index: true
      t.string :name, null: false
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
