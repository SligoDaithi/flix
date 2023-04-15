class User < ApplicationRecord
  has_secure_password
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy 
  has_many :favorite_movies, through: :favorites, source: :movie 

  validates :name, presence: true
  validates :username, presence: true,
                       format: { with: /\A[A-Z0-9]+\z/i },
                       uniqueness: { case_sensitive: false }

  validates :email, presence: true,
                    format: { with: /\S+@\S+/ },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 10, allow_blank: true }
  
  scope :by_name, lambda { order(name: :asc)} 
  scope :non_admins, lambda { by_name.where(admin: false)}

  before_save :format_username
  before_save :format_email

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param 
    format_username 
  end

  private 

  def format_username 
    self.username = username.parameterize
  end
  
  def format_email 
    self.email = email.downcase 
  end
end
