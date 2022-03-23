class CreatePlayers < ActiveRecord::Migration[7.0]
  def down
    change_table :players do |t|
      t.remove :username
    end
  end
end
