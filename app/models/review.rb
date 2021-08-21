class Review < ApplicationRecord
  belongs_to :store
  belongs_to :user
  counter_culture :store

  validates :store_id, presence: true
  validates :user_id, presence: true
  validates :rating, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 0.5 }
  validates :comment, presence: true, length: { maximum: 140 }
  validates :store_id, uniqueness: { scope: :user_id }
end
