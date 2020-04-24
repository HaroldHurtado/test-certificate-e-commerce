class CreatePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :preferences do |t|
      t.string :preference_id
      t.integer :order_id

      t.timestamps
    end
  end
end
