# require_relative './human.rb'
class House < ActiveRecordBase
  has_many :humans, {foreign_key: :house_id}
  has_many_through :dogs, :humans, :dogs
end