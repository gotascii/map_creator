################################################################################
#
# Creates and manipulates the objects described in reaktormap.rb.
#
################################################################################
class MapFileCreator
  
  # A counter variable for the number of Reaktor maps created.
  # Expected: Integer.
  #
  attr_reader :num_maps

  # A counter variable for the number of audio files acquired.
  # Expected: Integer.
  #
  attr_reader :num_files
  
  # A counter variable for the number of directories mapped.
  # Expected: Integer.
  #
  attr_reader :num_dirs

	##############################################################################  
	#
	# Initialize the object's instance variables.
	# Expects: A GUIBundle.
	#
  def initialize(bundle)
  
  	# Initialize the reader variables.
  	#
    @num_maps = 0
    @num_files = 0
    @num_dirs = 0
    
    @gui = bundle
    
    # Calculate the key and velocity range and increment.
    #
    @key_range = (@gui.high_key - @gui.low_key).abs + 1    
    if (@gui.high_key - @gui.low_key) < 0
    	@key_inc = -1
    else
    	@key_inc = 1
    end
    
    @vel_range = (@gui.high_vel - @gui.low_vel).abs + 1    
    if (@gui.high_vel - @gui.low_vel) < 0
    	@vel_inc = -1
    else
    	@vel_inc = 1
    end
    		
  end

	##############################################################################
	#
	# Scans a directory for any audio files and / or subdirectories.
	#
	# Expects: a directory to scan.
	# Returns: an array of AudioFile.
	#
  def scan_dir(dir)

    puts "Scan dir : " + dir
    
    audio_files = Array.new

		# If recursion is enabled scan for all subdirectories.
		#
		directories = Array.new		
		if @gui.recurse != nil
    	directories = Dir.entries(dir).sort.delete_if {|item| !File.directory?(dir + "/" + item) || item.length < 3}
    end
    
    puts "Acquired " + directories.length.to_s + " subdirectories"
    
    # Scan for all audio files in the specified directory.
		#
		files = Dir.entries(dir).sort.delete_if {|item| File.extname(item).downcase != ".wav" && File.extname(item).downcase != ".aif" && File.extname(item).downcase != ".aiff"}
    
    puts "Acquired " + files.length.to_s + " audio files"
    
    # Load all audio files into AudioFile objects, append to an array.
    #
		files.each do |name|
			audio_files << AudioFile.new(dir, name)
#			puts "Pre-loaded: " + audio_files[-1].name + " in " + audio_files[-1].path
		end
    
    # Recurse through all subdirectories if recursion is enabled.
    #
    if @gui.recurse != nil    	
    	directories.each do |item|
      	audio_files = audio_files + scan_dir(dir + "/" + item)
    	end    
  	end
  	
  	return audio_files

  end

  ##############################################################################
  #
  # Provides a name and path for a new MapFile given an AudioFile.
  #
  # Expects: an AudioFile.
  # Returns: a path and a file name.
  #
  def name_map(audio_file)
    
  	# Implement the naming scheme.
  	#

    if @gui.map_name != nil && @gui.map_path != nil
    	map_name = @gui.map_name + "_" + @num_maps.to_s + ".map"
    	map_path = @gui.map_path 
    elsif @gui.map_name != nil
    	map_name = @gui.map_name + ".map"
    	map_path = audio_file.path
    elsif @gui.map_path != nil
    	map_name = File.basename(@gui.map_path) + "_" + @num_maps.to_s + ".map"
    	map_path = @gui.map_path 
    else
    	map_name = File.basename(File.dirname(audio_file.path)) + "_" + @num_maps.to_s + ".map"
    	map_path = audio_file.path
  	end
  	
#  	puts "map_path:" + map_path
#  	puts "map_name:" + map_name

  	return map_path, map_name
  	
	end

  ##############################################################################
  #
  # Load the audio files into MapFile objects.
  #
  # Expects: a non empty array of AudioFile.
  # Returns: an array of MapFile.
  #
  def fill_map(audio_files)
		
		# Set the counters and create an array of MapFile.
 		map_files = Array.new
 		@num_maps = 0
    @num_files = 0
    @num_dirs = 0
  	last_path = "ThisIsNotAPathName"
  	vel = 0
  	key = 0
		
   	audio_files.each do |a_file|
   		
      # Create the next entry.
  	  #
    	entry = MapEntry.new(a_file.path.gsub("/","\\"), a_file.name)
     	
  	  # Test if the directory has changed.
    	#
     	if a_file.path != last_path
     	
     		@num_dirs += 1
     		
     		# If it is the first iteration or if a new map is to be created for 
     		# every directory then create a new MapFile and set the counters.
     		#
     		if @gui.dir_to_map != nil || last_path == "ThisIsNotAPathName"
     			@num_maps += 1
     			map_path, map_name = name_map(a_file) 			 		    		
   				map_files << MapFile.new(map_path, map_name)
   				key = 0
   				vel = 0
   				
   				puts "Created new map " + map_name + " in " + map_path
   			end
   			
   			# If every directory is to be assigned a different velocity then set 
   			# the velocity and key counters.
   			#
   			if @gui.dir_to_vel != nil && last_path != ""
   				vel += @vel_inc
   				key = 0
   			end
    		
     	end
     		
     	# Assign data to the MapEntry.
     	# 
     	
     	# Assign the key values to the entry.
     	#
#     	puts "key nil?" + key.to_s
     	entry.lkey = key + @gui.low_key
      entry.rkey = key + @gui.low_key
     	
     	# Assign the velocity values to the entry.
     	#
     	if @gui.dir_to_vel != nil
     		entry.lvel = vel + @gui.low_vel
      	entry.rvel = vel + @gui.low_vel
      elsif @vel_inc > 0
      	entry.lvel = @gui.low_vel
      	entry.rvel = @gui.high_vel
      else
      	entry.lvel = @gui.high_vel
      	entry.rvel = @gui.low_vel
     	end
     	
     	# Assign the root value of the entry.
     	#
     	if @gui.root != nil
     		entry.root = @gui.root
     	else
     	  entry.root = entry.lkey
     	end
     	
     	# Test for boundary conditions.
     	#
     	if entry.lkey < @gui.low_key || entry.rkey > @gui.high_key
     		add_map = "FAIL"
#     		puts "Discarded " + a_file.name + " from " + a_file.path + " : Key assignment out of range!"
     	end
     	
     	if entry.lkey < 0 || entry.rkey > 127
     		add_map = "FAIL"
#     		puts "Discarded " + a_file.name + " from " + a_file.path + " : Key assignment out of range!"
     	end
     	
     	if entry.lvel < @gui.low_vel || entry.rvel > @gui.high_vel
     		add_map = "FAIL"
#     		puts "Discarded " + a_file.name + " from " + a_file.path + " : Velocity assignment out of range!"
     	end
     		
     	if entry.lvel < 0 || entry.rvel > 127
     		add_map = "FAIL"
#     		puts "Discarded " + a_file.name + " from " + a_file.path + " : Velocity assignment out of range!"
     	end
     		
     	# Add the entry to a MapFile.
     	#
     	
     	if add_map != "FAIL"
      	map_files[-1].mapentry_array << entry
#      	puts "Added: " + a_file.name + " from " + a_file.path
#      	puts "To the sample map: " + map_files[-1].name + " in " + map_files[-1].path
      	@num_files += 1
      end
      	
  		# Increment all relevant counters.
  		#
  			
  		key += @key_inc
  		last_path = a_file.path
  		add_map = "PASS"
    	
    end
    
    return map_files
    
  end
  
  ##############################################################################
  #
  # The main line of execution.
  #
  # Returns: the number of maps created.
  # Returns: the number of containing directories.
  # Returns: the number of audio files mapped.
  #
  def build_maps
    
    if @gui.sample_path != nil
    	audio_files = scan_dir(@gui.sample_path)
    	if audio_files != nil
    		map_files = fill_map(audio_files)
    		if map_files != nil
	    		map_files.each do |map_file|
  	  			builder = MapFileBuilder.new
    				builder.write_mapfile(map_file)
    			end
    		end
    	end
    end
    
    return @num_maps, @num_dirs, @num_files
    
	end
 
end
