class AddingAssociations < ActiveRecord::Migration[7.0]
  def change
    change_table :games do |t|
      t.integer :creator_id
    end
  end
end
