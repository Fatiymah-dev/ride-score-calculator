class Ride < ApplicationRecord
  belongs_to :driver
  validates :start_address, :destination_address, presence: true
  scope :ordered_by_score, -> { order(score: :desc) }
end
