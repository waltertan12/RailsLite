class Human < ActiveRecordBase
  self.table_name = "humans"
  validates :name, presence: true
  validates :name, length: { minimum: 1 }

  belongs_to :house
  has_many :dogs
end