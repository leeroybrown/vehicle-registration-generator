# Creates a registration mark following the rules set out in the brief
# @param row [Array] of hash's representing each row of the vehicles.csv
# @return vehicle [Vehicle]

def build_reg_mark(row:)
  vehicle = Vehicle.new(vehicle_data: row)
  Validation.area_code(registration_area: row[:registrationarea].to_sym, vehicle: vehicle)
  Validation.age_identifier(date_to_validate: row[:dateofmanufacture], vehicle: vehicle)
  Validation.create_random_letters(vehicle: vehicle)
  Validation.validate_complete_reg_mark(reg_mark: vehicle.reg_mark)

  vehicle
end

# Creates an array of valid and invalid Vehicle objects
# @param vehicle_data [Array] of hash's representing each row of the vehicles.csv
# @return valid_registration_marks [Array]
# @return invalid_registration_marks [Array]
# @return registration_per_area [Hash]

def reg_mark_engine(vehicle_data:)
  unique_reg_marks = Set.new
  valid_registration_marks = []
  invalid_registration_marks = []
  registration_per_region = { :cardiff => 0,
                              :swansea => 0,
                              :birmingham => 0
  }
  vehicle_data.each do |row|
    vehicle_record = build_reg_mark(row: row)
    unless vehicle_record.errors.has_key?(:unknown_area_code)
      duplicate_count = 0
      while unique_reg_marks.include?(vehicle_record.reg_mark) # while generated reg mark is a duplicate
        if duplicate_count < Constants::RegMarkAttempts::REG_MARK_ATTEMPTS # is my attempts to create a unique reg mark under 10?
          vehicle_record = build_reg_mark(row: row) # attempt to create a unique one
          duplicate_count += 1 # increment counter by 1
        else # there's still a duplicate reg mark but i've made 10 attempts and failed to create a unique one
          vehicle_record.errors[:duplicate_reg_mark] = vehicle_record.reg_mark # update my vehicle record errors to show a duplicate reg mark
          break # break out of the loop as I'm not prepared to try anymore
        end
      end
      unique_reg_marks << vehicle_record.reg_mark
    end

    if vehicle_record.errors.empty?
      valid_registration_marks << vehicle_record
      registration_per_region[vehicle_record.registration_area.to_sym] += 1
    else
      invalid_registration_marks << vehicle_record
    end
  end
  [valid_registration_marks, invalid_registration_marks, registration_per_region]
end

# Summarises the data on the screen for the user
# @param valid_vehicles [Array]
# @param invalid_vehicles [Array]
# @param per_area [Hash]
# @return nil [NilClass]

def summarise_data(valid_vehicles:, invalid_vehicles:, per_area:)

  puts "\n          Vehicle Registration Generator \n\n"

  # number of valid registration marks generated
  puts "Total number of valid registration marks generated: #{valid_vehicles.count}\n\n"

  # total number of registration marks generated per area
  puts "Breakdown of each region:"
  per_area.each { |key, value| puts "#{key}: #{value}" }

  # total number of registration marks unable to generate
  puts "\nTotal number of registration marks unable to be determined: #{invalid_vehicles.count}"

  # total number of records processed
  puts "Total number of records processed: #{valid_vehicles.count + invalid_vehicles.count}"

end

# Handles the running of the program
# @param none
# @return nil [NilClass]

def vehicle_registration_generator
  file = FileHandler.read_file(file_name: Constants::FilePath::INPUT_FILE_PATH)
  valid_registration_marks, invalid_registration_marks, registration_per_region = reg_mark_engine(vehicle_data: file)

  valid_reg_marks = FileHandler.write_file(file_name: 'valid_reg_marks', vehicle: valid_registration_marks)
  invalid_reg_marks = FileHandler.write_file(file_name: 'invalid_reg_marks', vehicle: invalid_registration_marks)

  summarise_data(valid_vehicles: valid_registration_marks,
                 invalid_vehicles: invalid_registration_marks,
                 per_area: registration_per_region)

  if valid_reg_marks && invalid_reg_marks
    puts "\nSuccess: Valid and invalid files have been saved in '#{Constants::FilePath::OUTPUT_FILE_PATH}' directory."
  end
end
