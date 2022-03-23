class Player < ApplicationRecord
  belongs_to :game

  validates :name, presence: true
  validates :password, presence: true
  validates :target, presence: true
  validates :dead, inclusion: { in: [true, false ] }
end
