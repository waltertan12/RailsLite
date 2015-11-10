# Active Record Lite
This is a reimplementation of some of ActiveRecord's core features, namely, model persistence, querying, and basic associations.

### Models
Just like in Ruby on Rails, you can create normal ruby classes that inherit from ActiveRecordBase. Simply define the classes using the following format:
````ruby
class ClassName < ActiveRecordBase
  # You can write model level validations using the ActiveRecordBase#validates method.
  # Currently, ActiveRecordBase#validates can only check for uniqueness, presence, and length
  # Simply write it in this form
  validates :column_name, presence: true
  validates :column_name, length: {minimum: 8}
  validates :column_name, uniqueness: true
end
````
Unlike normal Rails, you cannot write an #initialize method in the class. The columns you declare in the `db/schema.sql` file dictates the instance variables in each class.

### Schema
Define the schema for the application in the `db/schema.sql` file. Unfortunately, this must be written in pure SQL:

````SQL
CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  happiness_level INTEGER NOT NULL
);
````