class Killrequest < ApplicationRecord
  validates :game_id, presence: true
  validates :assassin_id, presence: true
  validates :victim_id, presence: true
end
