################################################################################
#
# A Reaktor map entry associated with an audio file.
# This object can be flattened to a string of data and written to disk.
#
################################################################################
class MapEntry
  
  # Lowest MIDI pitch value the sample will be triggered by.
  # Expected: 7bit unsigned integer.
  #
  attr_accessor :lkey
  
  # Highest MIDI pitch value the sample will be triggered by.
  # Expected: 7bit unsigned integer.
  #
  attr_accessor :rkey
    
  # Lowest MIDI velocity value the sample will be triggered by.
  # Expected: 7bit unsigned integer.
  #
  attr_accessor :lvel 

	# Highest MIDI velocity value the sample will be triggered by.
  # Expected: 7bit unsigned integer.
  #
  attr_accessor :rvel
  
  # The root of the note for transposition.
  # Expected: 7bit unsigned integer.
  #
  attr_accessor :root
  
  # The tuning of the sample in cents.
  # Expected: 32bit signed float.
  #
  attr_accessor :tune
  
  # The gain applied to the sample in decibles.
  # Expected: ?Signed float?
  #
  attr_accessor :gain
  
  # The panning position of the sample.
  # Expected: Signed float [-100...100]  
  #
  attr_accessor :pan
  
  # Enable looping.
  # Expected: ?Integer? 0 = off
  #
  attr_accessor :looping
  
  # The sample will loop from this sample offset.
  # Expected: Unsigned integer less than the length of the audiofile in samples.
  #
  attr_accessor :loopstart
  
  # The sample will return to loopstart at this sample offset.
  # Expected: Unsigned integer less than the length of the audiofile in samples.
  #
  attr_accessor :loopend
  
  ##############################################################################
  #
  # The map entry must be initialized with a file name and an associated path.
  #
  # Expected: The file system path in which the audio file is located.
  # Expected: The name of the audio file.
  #
  def initialize(path, name)
   	
   	# Initialize variables with the given parameters.
    @path = path
    @name = name
    
    # Initialize accessor variables with default values.
    @lkey 			= 0
    @rkey 			= 127
    @lvel 			= 0
    @rvel 			= 127
    @root 			= 0
    @tune 			= 0
    @gain 			= 0
    @pan 				= 0
    @looping 		= 0
    @loopstart 	= 0
    @loopend 		= 0
    
  end
  
  ##############################################################################
  #
  # Construct a data string from the information in the map entry in preparation
  # for a write to disk.
  #
  # Expected: A MapFileBuilder object.
  #
  def build(builder)
  
    # Sample file path : String
    builder.append_string(@path)
    
    # Sample file name : String
    builder.append_string(@name)
    
    # Unknown byte sequence, same in all files so far
    builder.append_hex("04000000")
    builder.append_hex("00000000")
    builder.append_hex("656E7472")
    builder.append_hex("54000000")
    builder.append_hex("02000000")

    # Key zone / Velocity / Root Key stuff
    builder.append_int(@lkey)
    builder.append_int(@rkey)
    builder.append_int(@lvel)
    builder.append_int(@rvel)
    builder.append_int(@root)

    # unknown
    builder.append_hex("00000000")
    
    # Tune. 32 bit signed float
    builder.add_float(@tune)
    
    # ? Gain. Unknown format, probably 32 bit signed float
    builder.add_float(@gain)
    
    # ? Pan. Unknown format, probably 32 bit signed float
    builder.add_float(@pan)
    
    # Unknown byte data
    builder.append_hex("FFFFFFFF") 
    builder.append_hex("FFFFFFFF") 
    builder.append_hex("00000000")
    
    # ? loop on. Unknown format, assume int for now
    builder.append_int(@looping)
    
    # More unknown data
    builder.append_hex("00000000")
    builder.append_hex("01000000")
    
    # Loop start : 32 bit int
    builder.append_int(@loopstart)
    builder.append_int(@loopend)
    
    # Unknown
    builder.append_hex("00000000")
    
    # End of sample data, seems identical in all entries so far
    builder.append_hex("55000000")
    builder.append_hex("06426200")
    
  end

end

