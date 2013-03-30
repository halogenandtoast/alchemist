module Alchemist
  def self.register_operation_conversions type, other_type, operation, converted_type
    operator_actions[operation] ||= []
    operator_actions[operation] << [type, other_type, converted_type]
  end

  def self.operator_actions
    @operator_actions ||= {}
  end
end
