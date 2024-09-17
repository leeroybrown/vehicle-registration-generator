require_relative 'constants'

module Validation

  # Creates first two letters of the registration mark based on rules and stores it in Vehicle object
  # @param registration_area [Symbol]
  # @param vehicle [Vehicle]
  # @return valid first two letters of registration mark [String]

  def self.area_code(registration_area:, vehicle:)
    valid_codes = {
      :swansea => {
        :first_letter => 'C',
        :second_letter => %w[A B C D E F G H J K].sample
      },
      :cardiff => {
        :first_letter => 'C',
        :second_letter => %w[L M N P Q R S T U V W X Y Z].sample
      },
      :birmingham => {
        :first_letter => 'B',
        :second_letter => %w[A B C].sample
      }
    }
    if valid_codes.has_key?(registration_area)
      vehicle.reg_mark =
        "#{valid_codes[registration_area][:first_letter]}#{valid_codes[registration_area][:second_letter]}"
    else
      vehicle.errors[:unknown_area_code] = registration_area
    end
  end

  # Creates age identifier digits based on given date and appends to the Vehicle object
  # @param date_to_validate [String]
  # @param vehicle [Vehicle]
  # @return nil [NilClass]

  def self.age_identifier(date_to_validate:, vehicle:)
    extract_date = Date.parse(date_to_validate)
    if vehicle.errors.empty?
      if extract_date.month.between?(3, 8)
        age = extract_date.strftime('%y')
      else
        age = (extract_date.strftime('%y').to_i + Constants::AgeIdentifier::YEARS_TO_ADD).to_s
      end
      vehicle.reg_mark += " #{age}" # whitespace plus age as per brief
    end
  end

  # Creates three random letters, uses RegEx to check these are valid and appends to Vehicle object
  # @param vehicle [Vehicle]
  # @return nil [NilClass]

  def self.create_random_letters(vehicle:)
    if vehicle.errors.empty?
      valid_letters = false
      until valid_letters
        random_letters = Faker::Alphanumeric.alpha(number: 3).upcase
        if random_letters.match(Constants::PatternMatch::RANDOM_LETTERS)
          vehicle.reg_mark += " #{random_letters}"
          valid_letters = true
        end
      end
    end
  end

  # Validates the completed registration mark against RegEx
  # @param reg_mark [String]
  # @return nil [NilClass]

  def self.validate_complete_reg_mark(reg_mark:)
    # check registration mark complies with the correct format
    unless reg_mark.empty?
      raise "Invalid Reg Mark: #{reg_mark}" unless reg_mark.match(Constants::PatternMatch::COMPLETE_REG_MARK_PATTERN)
    end
  end
end
