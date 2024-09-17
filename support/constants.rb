module Constants
  module PatternMatch
    COMPLETE_REG_MARK_PATTERN = /^([[:upper:]]){2} (?!00|01|50)([[:digit:]]){2} ((?!(I|K|M|Y))[[:upper:]]){3}$/
    RANDOM_LETTERS = /^((?!(I|K|M|Y))[[:upper:]]){3}$/
  end

  module FilePath
    INPUT_FILE_PATH = 'raw_data/vehicles.csv'
    OUTPUT_FILE_PATH = 'output/'
  end

  module OutputHeaders
    HEADERS = %w[Make Colour DateOfManufacture Vin RegistrationArea Errors RegMark]
  end

  module AgeIdentifier
    YEARS_TO_ADD = 50
  end

  module RegMarkAttempts
    REG_MARK_ATTEMPTS = 10
  end
end
