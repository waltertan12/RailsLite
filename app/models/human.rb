class Human < ActiveRecordBase
  self.table_name = "humans"
  validates :name, presence: true

  belongs_to :house
  has_many :dogs
end