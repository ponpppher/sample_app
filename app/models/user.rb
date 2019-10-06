class User < ApplicationRecord
  has_secure_password
  before_save { email.downcase! }
  validates :name , presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string)
    const = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: const)
  end

end
