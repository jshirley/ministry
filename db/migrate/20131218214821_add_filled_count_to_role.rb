class AddFilledCountToRole < ActiveRecord::Migration
  def change
    add_column :roles, :filled_count, :integer, null: false, default: 0
  end
end
