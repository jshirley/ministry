class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.references :project, index: true
      t.references :user, index: true
      t.string :name
      t.date :date
      t.boolean :success

      t.timestamps
    end
  end
end
