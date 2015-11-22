class Dog < ActiveRecordBase
  validates :name, presence: true
  validates :name, length: { minimum: 1 }

  belongs_to :human
  has_one_through :house, :human, :house
end