# require_relative './human.rb'
class House < ActiveRecordBase
  validates :name, presence: true
  validates :name, length: { minimum: 1 }
  
  has_many :humans, {foreign_key: :house_id}
  has_many_through :dogs, :humans, :dogs
end