class AddStateToProject < ActiveRecord::Migration
  def change
    add_column :projects, :aasm_state, :text
  end
end
