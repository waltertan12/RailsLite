require 'sqlite3'

require_relative '../../config/root_path'

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    
    tables = @db.execute(<<-SQL)
      SELECT 
        name 
      FROM 
        sqlite_master
    SQL

    if tables.empty?
      self.reset(db_file_name, SQL_FILE)
    end

    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset(db_file_name, sql_file)
    commands = [ 
      "rm '#{db_file_name}' ", 
      "cat '#{sql_file}' | sqlite3 '#{db_file_name}'" 
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(db_file_name)
  end

  def self.instance
    # reset if @db.nil?
    open(DB_FILE) if @db.nil?

    @db
  end

  def self.execute(*args)
    # puts args[0]

    instance.execute(*args)
  end

  def self.execute2(*args)
    # puts args[0]

    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private
  def initialize(db_file_name)
  end
end
