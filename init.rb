$LOAD_PATH << "."

require "gui_bundle"
require "audio_file"
require "map_file_creator"
require "map_file"
require "map_entry"

# 1. set_sample_dir Sample directory
# @lbl_src set to dir path
# 2. set_map_dir Map output directory
# @lbl_map set to dir path
# 3. build

class MapBuilderFrame

  def initialize
    wd = Dir.pwd
    @sample_dir = ENV.fetch('SAMPLE_DIR', wd)
    @map_dir = ENV.fetch('OUTPUT_DIR', wd)

    # Fix root note at 60
    @chk_fixrootnote = ENV['FIX_ROOT']
    # Map directories to velocities
    @chk_dir_to_vel = ENV['VEL']
    # Scan sub-dirs
    @chk_recurse = ENV['SCAN']
    # One map per dir
    @chk_dir_to_map = ENV['MAP_DIRS']

    build
  end

  def build
    bundle = GUIBundle.new(@sample_dir)
    bundle.map_path = @map_dir
    if @chk_fixrootnote
      bundle.root = 60;
    end
    if @chk_dir_to_vel
      bundle.dir_to_vel = 1;
    end
    if @chk_recurse
      bundle.recurse = 1;
    end
    if @chk_dir_to_map
      bundle.dir_to_map = 1;
    end
    create = MapFileCreator.new(bundle)
    num_maps, num_dirs, num_files = create.build_maps

    puts "Built " + num_maps.to_s + " map(s) from " + num_dirs.to_s + " director(y/ies) and " + num_files.to_s + " sample(s)."
  end
end

MapBuilderFrame.new
