class User < ApplicationRecord
  validates :name, :password_digest, :session_token, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}

  attr_reader :password
  after_initialize :ensure_session_token

  has_many :posts, inverse_of: :author

  has_many :subs,
  foreign_key: :moderator_id,
  class_name: 'Sub',
  inverse_of: :moderator

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def ensure_session_token
    self.session_token = SecureRandom::urlsafe_base64
  end

  def reset_session_token
    self.session_token = SecureRandom::urlsafe_base64
    self.save
    self.session_token
  end

  def self.find_by_credentials(name, password)
    user = User.find_by(name: name)
    return nil unless user && user.valid_password?(password)
    user
  end
end
