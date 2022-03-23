class CreateKillrequests < ActiveRecord::Migration[7.0]
  def change
    create_table :killrequests do |t|
      t.integer :assassin_id
      t.integer :victim_id
      t.integer :game_id

      t.timestamps
    end
  end
end
