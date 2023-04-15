class Movie < ApplicationRecord
   
  has_many :reviews, lambda { order(created_at: :desc) }, dependent: :destroy
  has_many :favorites, dependent: :destroy 
  has_many :fans, through: :favorites, source: :user 
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy 
  has_many :genres, through: :characterizations

  validates :title, presence: true, uniqueness: true 
  validates :released_on, :duration, presence: true 
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 } 
  validates :image_file_name, format: {
      with: /\w+\.(jpg|png)\z/i,
      message: "must be a JPG or PNG image"
  }
  RATINGS = %w(G PG PG-13 R NC-17) 
  validates :rating, inclusion: { in: RATINGS }

  scope :released, lambda { where("released_on < ?", Time.now).order("released_on desc") }
  scope :upcoming, lambda { where("released_on > ?", Time.now).order("released_on asc") }
  scope :recent, lambda { |max=5| released.limit(max) }
  scope :hits, lambda { released.where("total_gross >= 300000000").order(total_gross: :desc) }
  scope :flops, lambda { released.where("total_gross < 225000000").order(total_gross: :asc) }
  scope :grossed_less_than, lambda { |values=250000000| released.where("total_gross < ?", values) }
  scope :grossed_greater_than, lambda { |values=400000000| released.where("total_gross > ?", values) }

  before_save :set_slug 

  def average_stars 
    reviews.average(:stars).to_i || 0.0 
  end

  def average_stars_as_percent
    (self.average_stars / 5.0) * 100
  end

  def flop?
    if (reviews.count < 50 && average_stars < 4)
      (total_gross.blank? || total_gross < 225000000)
    end 
  end

  def to_param
    slug
  end

  private 

  def set_slug
    self.slug = title.parameterize 
  end
end
