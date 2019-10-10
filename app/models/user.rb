class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  has_secure_password
  validates :name , presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  # def authenticated?(remember_token)
    # return false if remember_digest.nil?
    # BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # ユーザーの有効化
  def activate
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # ユーザー有効化のメール送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

    # all mail address convert down case
    def downcase_email
      email.downcase!
    end

    # create activate token and digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
