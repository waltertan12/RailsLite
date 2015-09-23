require_relative '03_associatable'

# Phase IV
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

      final_klass.where({ final_col => final_id }).first
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
