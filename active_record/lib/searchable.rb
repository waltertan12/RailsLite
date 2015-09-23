require_relative 'db_connection'

module Searchable
  def where(params)
    values = []

    attributes = params.map do |attribute, value|
      values << value
      attribute.to_s + " = ?"
    end

    attributes_string = attributes.join(" AND ")

    found_items = DBConnection.execute2(<<-SQL, *values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{attributes_string}
    SQL

    parse_all(found_items.drop(1))
  end
end