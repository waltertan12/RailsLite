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
      relation = klass.where(foreign_key => key_value).load
      relation.records
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

module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options
  #  TODO: Refactor by writing all this in SQL
  def has_one_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]

    define_method(name) do
      source_options  = 
        through_options.model_class.assoc_options[source_name]
      
      join_klass  = through_options.model_class
      join_key    = through_options.foreign_key
      join_id     = self.send(join_key)
      join_object = join_klass.find(join_id)

      final_klass = source_options.model_class
      final_key   = source_options.foreign_key
      final_col   = source_options.primary_key
      final_id    = join_object.send(final_key)

      relation = final_klass.where({ final_col => final_id })
      relation.load
      relation.records.first
    end
  end
  # TODO: Refactor by writing all this in SQL
  def has_many_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]

    define_method(name) do
      source_options  = 
        through_options.model_class.assoc_options[source_name]
      
      join_klass  = through_options.model_class
      join_key    = through_options.foreign_key
      # join_id     = join_klass.send()
      join_objects = join_klass.where({join_key => id})
      
      final_klass = source_options.model_class
      final_key   = source_options.primary_key
      final_col   = source_options.foreign_key
      final_ids   = []
      join_objects.each do |join_object|
        final_ids << join_object.send(final_key)
      end

      result = []

      final_ids.each do |final_id|
        result += final_klass.where({ final_col => final_id })
      end

      result
    end
  end
end
