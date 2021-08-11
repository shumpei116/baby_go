class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :store
  counter_culture :store

  validates :user_id, presence: true
  validates :store_id, presence: true

  validates :store_id, uniqueness: { scope: :user_id }
end
