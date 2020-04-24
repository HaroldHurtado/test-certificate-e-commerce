class RenameDesccriptionToDescription < ActiveRecord::Migration[6.0]
  def change
      rename_column :orders, :desccription, :description
  end
end
