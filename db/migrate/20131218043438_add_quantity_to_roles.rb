class AddQuantityToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :quantity, :integer, default: 0
  end
end
