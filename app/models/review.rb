class Review < ApplicationRecord
  belongs_to :movie
  validates :name, :stars, presence: true 
  validates :stars, numericality: { in: 1..5, message: "must be between 1 and 5" }
  validates :comment, length: { minimum: 4 }
end
