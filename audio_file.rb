################################################################################
#
# Object for storing data about audio files.
#
################################################################################
class AudioFile
	
	# The path containing the audio file.
	# Expected: A valid file system path.
	#
  attr_accessor :path
  
  # The name of the audio file.
	# Expected: A valid file name.
	#
  attr_accessor :name
  
	##############################################################################  
	#
	# Initialize the accessor variables.
	# Expected: the path of the audio file.
	# Expected: the name of the audio file.
	#
  def initialize(file_path, file_name)
  	@path = file_path
  	@name = file_name
	end
	
end

