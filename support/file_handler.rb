module FileHandler

  # Opens and processes the specified file, raises an error if the file does not exist
  # @param file_name [String] the file to open
  # @return [Array] of hashes representing each line of the file

  def self.read_file(file_name:)
    raise StandardError, "File #{file_name} not found" unless File.exist?(file_name)

    SmarterCSV.process(file_name)

  end

  # Creates and saves a file, raises an error if file cannot be saved
  # @params file_name [String] specifies name of the file to save
  # @params vehicle [Array] objects to write to each line
  # @return true [Boolean] if successfully saved the file

  def self.write_file(file_name:, vehicle:)
    array_of_objects_to_string = vehicle.map { |vehicle| vehicle.convert_instance_variables_to_strings }
    begin
      Dir.mkdir(Constants::FilePath::OUTPUT_FILE_PATH) unless Dir.exist?(Constants::FilePath::OUTPUT_FILE_PATH)
      CSV.open("#{Constants::FilePath::OUTPUT_FILE_PATH}/#{file_name}.csv",
               'w', write_headers: true, headers: Constants::OutputHeaders::HEADERS) do |line|
        array_of_objects_to_string.each { |record| line << record }
      end
    rescue Errno::ENOENT => error
      raise "Error whilst attempting to save file: #{error}"
    else
      true
    end
  end
end
