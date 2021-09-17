class User < ApplicationRecord
  before_save :downcase_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :avatar, AvatarUploader

  has_many :stores, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_stores, through: :favorites, source: :store
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }

  def already_favorited?(store)
    favorites.exists?(store_id: store.id)
  end

  def already_reviewed?(store)
    reviews.exists?(store_id: store.id)
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲストユーザー'
      user.introduction = 'ゲストユーザーです！'
    end
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
