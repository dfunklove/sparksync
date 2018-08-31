class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :firstName, presence: true, length: { maximum: 25 }
  validates :lastName, presence: true, length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password
  has_many :login

  def admin?
  	type == 'Admin'
  end
end
