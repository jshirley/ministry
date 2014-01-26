class AddRetrospectiveToField < ActiveRecord::Migration
  def change
    add_column :fields, :retrospective, :boolean, default: false
  end
end
