################################################################################
#
# Builds a string of binary data ready for writing to a map file.
# All data is little endian.
#
################################################################################
class MapFileBuilder
  
  def initialize
    @data = ""
  end

	##############################################################################
	#
  # Converts a MapFile to a Reaktor map and writes to disk.
  #
  # Expected: A MapFile object.
  #
  def write_mapfile(map)
    
    @data = ""
        
    map.build(self)
    
    begin
      file = File.new(map.path + "/" + map.name, "wb")
      file.print(@data)
      file.close
      puts "Wrote map file " + map.path + "/" + map.name
    rescue StandardError => err
      puts "Error creating file " + err
      puts "Path is " + map.path + "/" + map.name
    end

  end
  
  ##############################################################################
  #
  # Convert each pair of hex chars into a byte and append to the string of data.
  #
  # Expected: A string of hexadecimal characters.
  #
  def append_hex(hexstring)
  
    # convert each pair of hex chars into a byte
    a = [hexstring]
    @data << a.pack("H*")
    
  end

	##############################################################################
  #
  # Append text to the string of data.
  #  
  # Expected: A text string.
  #
  def append_text(text)
    @data << [text].pack("a*")
  end
  
  ##############################################################################
  #
  # Append a string to the string of data.
  #  
  # Expected: A string.
  #
  def append_string(str)
  
    # write string length as 32 bit unsigned int
    a = [str.length]
    @data << a.pack("L")
    
    # write string
    b = [str]
    @data << b.pack("a*")
    
  end
  
  ##############################################################################
  #
  # Append an integer to the string of data.
  #  
  # Expected: An integer.
  #
  def append_int(val)
  
    # write int as 32 bit unsigned int
    a = [val]
    @data << a.pack("L")
    
  end

	##############################################################################
  #
  # Append a little endian single precision float to the string of data.
  # 
  # Expected: A little endian single precision float.
  #    
  def add_float(val)
  
    # little endian single precision float
    a = [val]
    @data << a.pack("e")
    
  end
  
end
