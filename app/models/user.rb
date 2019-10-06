class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password
  before_save { email.downcase! }
  validates :name , presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  class << self
    # def User.digest(string)
    # def self.digest(string)
    def digest(string)
      const = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

      BCrypt::Password.create(string, cost: const)
    end

    # 新たなトークンを取得する
    # def User.new_token
    # def self.new_token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続化セッションのため、トークンをダイジェストに変換し、DBに保存する
  def remember
    # self.remember_token = User.new_token
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
