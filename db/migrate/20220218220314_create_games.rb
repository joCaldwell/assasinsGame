class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :game_code
      t.boolean :is_active

      t.timestamps
    end
  end
end
