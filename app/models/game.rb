class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  #belongs_to :creator, :class_name => "Player", :foreign_key => :creator_id


  validates :game_code, presence: true
  validates :is_active, inclusion: { in: [ true, false ] } 
end
