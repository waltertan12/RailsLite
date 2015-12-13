module Validatable
  def validates(column, options = {})
    @to_validate = {} if @to_validate.nil?
    @to_validate[column] = options
  end

  def valid?(object)
    return true if @to_validate.nil?
    @to_validate.all? do |column, validation|
      instance_value = object.send(column)

      valid = true

      if !validation[:presence].nil?
        valid &= validation[:presence] == !instance_value.nil?
      end

      if !validation[:uniqueness].nil?
        all_instances = self.all

        values = Set.new

        valid &= all_instances.all? do |instance|
          !values.add?(instance.send(column)).nil? && 
          instance_value != instance.send(column)
        end
      end

      if !validation[:length].nil?
        validation[:length].each do |len_validation|
          check = len_validation[0]
          param = validation[:length][check]

          puts "Instance Value: #{instance_value.length}"

          case check
          when :maximum
            valid &= instance_value.length <  param
          when :minimum
            valid &= instance_value.length >= param
          when :in
            valid &= instance_value.length <  param.max &&
            instance_value.length >= param.min
          end
        end
      end

      valid
    end
  end
end