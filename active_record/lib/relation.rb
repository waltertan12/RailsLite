class Relation
  attr_reader :klass, :table, :values, :loaded, :to_sql, :records

  def initialize(klass, table, values = {})
    @klass  = klass
    @table  = table
    @values = values
    @loaded = false
  end

  def where(values)
    case values
    when Hash
      Relation.new(@klass, @table, @values.merge(values))
    when String
      r = Relation.new(@klass, @table, @values)
      r.get_sql
      # determine if "AND" is needed
      conjunction = ""
      conjunction += "AND" if r.to_sql.match("AND")
      conjunction += "OR" if r.to_sql.match("OR")

      additional_query = r.to_sql + " #{conjunction} #{values}"
      r.instance_variable_set("@to_sql", additional_query)
      r
    end
  end

  def get_sql
    where_string = values.keys.map do |column_name|
      "#{column_name} = ?"
    end.join(" AND ")

    @to_sql = <<-SQL
      SELECT
        *
      FROM
        #{@table}
      WHERE
        #{where_string}
      SQL
      
    @to_sql.chomp!
  end

  def execute_query
    @loaded = true
    @to_sql ||= get_sql

    DBConnection.execute2(@to_sql, values.values)
  end

  def load
    unless loaded?
      @records = execute_query.drop(1).map { |attributes| klass.new(attributes) }
    end

    self
  end

  def loaded?
    @loaded
  end

  def to_a
    @records
  end

  def reset
    @klass = nil
    @table = nil
    @to_sql = nil
    @loaded = false
    @records = nil
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