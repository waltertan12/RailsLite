class Relation
  include Enumerable

  attr_reader :klass, :table, :values, :loaded, :to_sql

  def initialize(klass, table, values = {})
    @klass  = klass
    @table  = table
    @values = values
    @loaded = false
  end

  def where(values)
    Relation.new(@klass, 
                 @table, 
                 @values.merge(values)
    )
  end

  def get_sql
    where_string = values.keys.map do |column_name|
      "#{column_name} = ?"
    end.join(" AND ")

    <<-SQL
      SELECT
        *
      FROM
        #{@table}
      WHERE
        #{where_string}
    SQL
  end

  def execute_query
    @loaded = true
    @to_sql = get_sql

    DBConnection.execute2(@to_sql, values.values)
  end

  def load
    unless loaded?
      @records = execute_query.map { |attributes| klass.new(attributes) }
    end

    self
  end

  def loaded?
    @loaded
  end

  def to_a
    @records
  end

  def ==(other)
    case other
    when Relation
      to_sql == other
    when Array
      to_a == other
    end
  end
end