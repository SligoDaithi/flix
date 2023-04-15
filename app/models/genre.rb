class Genre < ApplicationRecord
  has_many :characterizations, dependent: :destroy 
  has_many :movies, through: :characterizations

  validates :name, presence: true,
    uniqueness: { case_sensitive: false } 

  before_save :set_slug

  def to_param 
    slug 
  end
  private 

  def set_slug 
    self.slug = name.parameterize 
  end
end
