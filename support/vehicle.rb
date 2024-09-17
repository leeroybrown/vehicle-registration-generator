class Vehicle
  attr_accessor :make, :color, :date_of_manufacture, :vin, :registration_area, :errors, :reg_mark

  # Create a vehicle object
  # @param vehicle_data [Array]
  # @return [Vehicle] with attributes

  def initialize(vehicle_data:)
    @make = vehicle_data[:make]
    @color = vehicle_data[:colour]
    @date_of_manufacture = vehicle_data[:dateofmanufacture]
    @vin = vehicle_data[:vin]
    @registration_area = vehicle_data[:registrationarea]
    @errors = {}
    @reg_mark = ''
  end

  # Creates string values from instance variables
  # @param [Vehicle]
  # @return [Array] of instance variables

  def convert_instance_variables_to_strings
    self.instance_variables.map{ |attribute| self.instance_variable_get(attribute).to_s }
  end
end
