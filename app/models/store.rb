class Store < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :introduction, presence: true, length: { maximum: 140 }
  VALID_POSTCODE_REGEX = /\A\d{3}\d{4}\z/.freeze
  validates :postcode, presence: true, format: { with: VALID_POSTCODE_REGEX }
  validates :prefecture_code, presence: true
  validates :city, presence: true, uniqueness: true
  VALID_URL_REGEX = %r{https?:/{2}[\w/:%#{Regexp.last_match(0)}?()~.=+\-]+}.freeze
  validates :url, format: { with: VALID_URL_REGEX }, allow_blank: true

  def average_rating
    ratings = reviews.map(&:rating)
    ratings.size.zero? ? 0.0 : ratings.sum.fdiv(ratings.size).round(2)
  end

  def self.average_score_rank
    left_joins(:reviews).includes(:reviews, :user).distinct.sort_by(&:average_rating)
                        .reverse
  end
end
