################################################################################
#
# A collection of map entries as defined by the MapEntry class.
# This object can be flattened to a string of data and written to disk.
#
################################################################################
class MapFile

	# The path of the audio file.
	# Expected: String.
  #
  attr_accessor :path
  
  # The file name of the audio file.
	# Expected: String.
  #
  attr_accessor :name
  
  # An array of MapEntry associated with the map.
	# Expected: Array of MapEntry.
  #
  attr_accessor :mapentry_array

	##############################################################################
  #
  # This object must be initialized with a file name and an associated path.
  #
  # Expected: The file system path in which the Reaktor map will be created.
  # Expected: The name of the new Reaktor map.
  #
  def initialize(path_name, file_name)
  
  	# Initialize variables with the given parameters.
    @path = path_name
    @name = file_name
    
    # Initialize the map entry array as nil.
    @mapentry_array = Array.new
    
  end

	##############################################################################
  #
  # Constructs a data string from the accessor variables in preparation for a
  # write to disk.
  #
  # Expected: A MapFileBuilder object.
  #
  def build(builder)
  
    # Header
    builder.append_hex("00000000")
    builder.append_hex("AB010000")
    
    #9 Bytes Text : NIMapFile
    builder.append_text("NIMapFile")
    
    # Map File Path : String
    builder.append_string(@path)
    
    # Map file name : String
    builder.append_string(@name)
    
    # Unknown byte sequence, same in all files so far
   builder.append_hex("070000006D6170700C0000000100000001000000000000000000000")
    
    # Number of samples in the map : Int.
    builder.append_int(@mapentry_array.length) 
    
    # Append all the entries as a string of data.
    @mapentry_array.each do |entry|
      entry.build(builder)
    end
    
  end
  
end

