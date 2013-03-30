module Alchemist
  register_operation_conversions(:distance, :distance, :*, :square_meters)
  register_operation_conversions(:area, :distance, :*, :cubic_meters)
  register_operation_conversions(:distance, :area, :*, :cubic_meters)
  register_operation_conversions(:area, :distance, :/, :meters)
  register_operation_conversions(:volume, :distance, :/, :square_meters)
  register_operation_conversions(:volume, :area, :/, :meters)
end
