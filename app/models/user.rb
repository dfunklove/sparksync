class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { self.email = email.downcase }
  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password

  # class method digest returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def admin?
  	type == 'Admin'
  end

  def teacher?
  	type == 'Teacher'
  end

  def partner?
  	type == 'Partner'
  end

  # Returns a random token to store as cookie
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    puts "attribute " + attribute.to_s + " token " + token
    puts "#{attribute}_digest"
    digest = send("#{attribute}_digest")
    puts digest.to_s
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
  #  update_attribute(:reset_digest,  User.digest(reset_token))
#    update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest:  User.digest(reset_token), \
                   reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
