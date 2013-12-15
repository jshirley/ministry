class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :project, index: true, null: false
      t.references :user, index: true
      t.references :role, index: true, null: false
      t.boolean :accepted, null: false, default: false
      t.boolean :approved, null: false, default: false
      t.boolean :active, null: false, default: true
      t.string :email, null: false
      t.text :note

      t.timestamps
    end
  end
end
