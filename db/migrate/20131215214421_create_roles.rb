class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :project, index: true
      t.string :name
      t.boolean :admin

      t.timestamps
    end
  end
end
