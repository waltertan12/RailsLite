require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] ||
                   ("#{name}".singularize.downcase + "_id").to_sym
    @primary_key = options[:primary_key] || :id 
    @class_name  = options[:class_name]  || "#{name}".capitalize.singularize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] ||
                   ("#{self_class_name}".singularize.downcase + "_id").to_sym
    @primary_key = options[:primary_key] || :id 
    @class_name  = options[:class_name]  || 
                   "#{name}".capitalize.singularize
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    self.assoc_options[name] = options
    
    define_method(name) do
      foreign_key = send(options.foreign_key)
      options.model_class.find(foreign_key)
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    klass = options.model_class
    self.assoc_options[name] = options

    define_method(name) do
      foreign_key = options.foreign_key
      key_value = send(options.primary_key)
      klass.where(foreign_key => key_value)
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    if @assoc_options
      @assoc_options
    else
      @assoc_options = {}
    end
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
