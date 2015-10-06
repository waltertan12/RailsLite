require_relative 'db_connection'

module Searchable
  def where(params)
    Relation.new(self, self.table_name, params)
  end
end