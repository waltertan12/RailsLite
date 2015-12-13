# require_relative 'db_connection'
require_relative './associatable'
require_relative './searchable'
require_relative './validatable'
require 'active_support/inflector'

class ActiveRecordBase
  extend Validatable
  extend Associatable
  extend Searchable

  def self.columns
    columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    method_names = columns.first.map {|item| item.to_sym}
    self.finalizer(method_names)
    method_names
  end

  def self.finalizer(columns)
    columns.each do |method_name|
      define_method(method_name) do
        attributes[method_name]
      end

      define_method("#{method_name}=") do |val|
        attributes[method_name] = val
      end
    end
  end

  def self.table_name=(table_name)
    instance_variable_set("@table_name", table_name.tableize)
  end

  def self.table_name
    table_name = instance_variable_get("@table_name")

    if table_name.nil?
      table_name = self.to_s.tableize
    end

    table_name
  end

  def self.all
    all = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    self.parse_all(all.drop(1))
  end

  def self.parse_all(results)
    results.map do |attributes|
      self.new(attributes)
    end
  end

  def self.find(id)
    specific_object = DBConnection.execute2(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL

    attributes = specific_object.drop(1).first

    unless attributes.nil?
      self.new(attributes)
    end
  end

  def initialize(params = {})
    params.each do |attribute, value|
      attr_name = attribute.to_sym

      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attribute}'"
      end

      attributes[attr_name] = value
    end
  end

  def attributes
    if @attributes.nil?
      @attributes = {}
    else
      @attributes
    end
  end

  def attribute_values
    self.class.columns.map do |column|
      self.send(column)
    end
  end

  def insert
    if self.class.valid?(self)
      column_names   = self.class
                        .columns
                        .drop(1)
                        .map { |elem| elem.to_s }.join(", ")
      num_of_columns = self.class
                        .columns
                        .drop(1)
                        .length
      question_marks = (["?"] * num_of_columns).join(", ")

      updated_attributes = attribute_values.drop(1)
      DBConnection.execute2(<<-SQL, *updated_attributes)
        INSERT INTO
          #{self.class.table_name} (#{column_names})
        VALUES
          (#{question_marks})
      SQL

      self.id = DBConnection.last_insert_row_id
    else
      false
    end
  end

  def update(new_attributes = {})
    new_attributes.each do |name, value|
      attributes[name.downcase.to_sym] = value
    end

    if self.class.valid?(self)
      set_string   = self.class
                         .columns
                         .drop(1)
                         .map { |elem| elem.to_s + (" = ?")}.join(", ")
      updated_attributes = attribute_values.drop(1)

      DBConnection.execute2(<<-SQL, *updated_attributes)
        UPDATE
          #{self.class.table_name}
        SET
          #{set_string}
        WHERE
          #{self.class.table_name}.id = #{id}
      SQL
    else
      false
    end
  end

  def destroy
    DBConnection.execute2(<<-SQL, id)
      DELETE FROM 
        #{self.class.table_name}
      WHERE 
        id = ?
    SQL
  end

  def save
    if id
      update
    else
      insert
    end
  end
end