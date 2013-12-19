class FixField < ActiveRecord::Migration
  def change
    rename_column :fields, :type, :input_type
  end
end
