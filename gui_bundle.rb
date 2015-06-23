################################################################################
#
# Object for passing data from the GUI to the map creation engine.
#
################################################################################
class GUIBundle
	
	# The root path containing audio files.
	# Expected: A valid file system path.
	#
  attr_accessor :sample_path

	# The path in which to create the new map. If "" is provided then the map will 
	# be created in the same directory as the first sample added to the map.
	# Expected: A valid file system path or "".
	#
  attr_accessor :map_path

	# The name of the new map. If "" is provided then the map name will be the
	# name of the containing directory of the first sample added to the map.
	# Expected: A valid file name or "".
	#
  attr_accessor :map_name
	
	# The lowest note to start sample mapping.
	# Expected: 7bit unsigned integer.
	#
  attr_accessor :low_key

	# The highest note to start sample mapping.
	# If this value is lower than the lowest note provided then the mapping will 
	# occur in reverse order.
	# Expected: 7bit unsigned integer.
	#
  attr_accessor :high_key
  
	# The root note of the samples. If this value is nil then the root will be 
	# equivalent to the key.
	# Expected: 7bit unsigned integer.
	#
  attr_accessor :root
	
	# The lowest velocity to start sample mapping.
	# Expected: 7bit unsigned integer.
	#
  attr_accessor :low_vel

	# The highest velocity to start sample mapping.
	# If this value is lower than the highest note provided then the mapping will 
	# occur in reverse order.
	# Expected: 7bit unsigned integer.
	#
  attr_accessor :high_vel

	# Whether to create a new map for every directory.
	# Expected: true != nil = false
	#
  attr_accessor :dir_to_map
  
  # Whether to map subdirectories to individual velocities.
	# Expected: true != nil = false
	#
  attr_accessor :dir_to_vel

	# Whether to scan subdirectories.
	# Expected: true != nil = false
	#
  attr_accessor :recurse

	##############################################################################  
	#
	# Initialize the accessor variables.
	# Expected: A valid path to begin scanning for audio files.
	#
  def initialize(dir)

  	@sample_path	= dir
	  @map_path 		= nil
  	@map_name 		= nil
	  @low_key 			= 0
  	@high_key 		= 127
  	@low_vel 			= 0
  	@high_vel 		= 127
	  @root 				= nil
  	@dir_to_vel 	= nil
  	@dir_to_map 	= nil
  	@recurse 			= nil
  	
	end
	
end

