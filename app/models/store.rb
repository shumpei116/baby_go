class Store < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :introduction, presence: true, length: { maximum: 140 }
  VALID_POSTCODE_REGEX = /\A\d{3}\d{4}\z/.freeze
  validates :postcode, presence: true, format: { with: VALID_POSTCODE_REGEX }
  validates :prefecture_code, presence: true
  validates :city, presence: true, uniqueness: true
  VALID_URL_REGEX = %r{https?:/{2}[\w/:%#{Regexp.last_match(0)}?()~.=+\-]+}.freeze
  validates :url, format: { with: VALID_URL_REGEX }, allow_blank: true
end
