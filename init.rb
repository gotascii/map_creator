require "gui_bundle"
require "audio_file"
require "map_file_creator"
require "map_file"
require "map_entry"
require "rubygems"
require "wx"
include Wx

# 1. set_sample_dir Sample directory
# @lbl_src set to dir path
# 2. set_map_dir Map output directory
# @lbl_map set to dir path
# 3. build

class MapBuilderFrame < Frame
  
  def initialize(builder)
    super(nil, -1, "Reaktor Map File Builder", Point.new(100,100),Size.new(500,175))
    @builder = builder
    
    main_panel = Panel.new(self, -1)
    
    btn_src_dir = Button.new(main_panel, -1, 'Set Sample Directory', Point.new(10, 10), Size.new(160, 20))
    btn_src_dir.evt_button(btn_src_dir.get_id) do | event|
      self.set_sample_dir(event)
    end

    @lbl_src = StaticText.new(main_panel, -1, '', Point.new(250,10), Size.new(100, 20))
    @lbl_src.set_label("Choose sample directory")
    
    btn_map_dir = Button.new(main_panel, -1, 'Set Output Directory', Point.new(10, 35), Size.new(160, 20))
    btn_map_dir.evt_button(btn_map_dir.get_id) do |event|
      self.set_map_dir(event)
    end

    @lbl_map = StaticText.new(main_panel, -1, '', Point.new(250,35), Size.new(100, 20))
    @lbl_map.set_label("Choose map directory")
    
    @chk_fixrootnote = CheckBox.new(main_panel,-1, 'Fix root note at 60', Point.new(10,60))
    
    @chk_dir_to_vel = CheckBox.new(main_panel,-1, 'Map directories to velocities', Point.new(240,60))
    
    @chk_recurse = CheckBox.new(main_panel,-1, 'Scan subdirectories', Point.new(10,85))
    
    @chk_dir_to_map = CheckBox.new(main_panel,-1, 'Create one map per directory', Point.new(240,85))

    btn_build = Button.new(main_panel, -1, 'Build Maps', Point.new(10, 110), Size.new(160, 20))
    btn_build.evt_button(btn_build.get_id) do |event|
      self.build(event)
    end

    @lbl_result = StaticText.new(main_panel, -1, '', Point.new(200,110), Size.new(100, 20))
  end

  def set_sample_dir(event)
    dir = DirDialog.new(self,  "Choose a directory")                               
    case dir.show_modal()
    when Wx::ID_OK
      @sample_dir = dir.get_path
      @lbl_src.set_label(@sample_dir)
    when Wx::ID_CANCEL
    end
  end
  
  def set_map_dir(event)
    dir = DirDialog.new(self,  "Choose a directory")                               
    case dir.show_modal()
    when Wx::ID_OK
      @map_dir = dir.get_path
      @lbl_map.set_label(@map_dir)
    when Wx::ID_CANCEL
    end
  end
  
  def build(event)
    if @sample_dir != nil && @map_dir != nil
    	bundle = GUIBundle.new(@sample_dir)
    	bundle.map_path = @map_dir
    	if @chk_fixrootnote.is_checked
        bundle.root = 60;
      end
      if @chk_dir_to_vel.is_checked
        bundle.dir_to_vel = 1;
      end
      if @chk_recurse.is_checked
        bundle.recurse = 1;
      end
      if @chk_dir_to_map.is_checked
        bundle.dir_to_map = 1;
      end
      create = MapFileCreator.new(bundle)
      num_maps, num_dirs, num_files = create.build_maps
      @lbl_result.set_label("Built " + num_maps.to_s + " map(s) from " + num_dirs.to_s + " director(y/ies) and " + num_files.to_s + " sample(s).")
    else
      dialog_options = Wx::NO_DEFAULT|Wx::OK|Wx::ICON_EXCLAMATION
      not_yet = Wx::MessageDialog.new(self, "You must choose the paths before generating", 
        "Not yet mate.", dialog_options )
      not_yet.show_modal()      
    end
  end
  
end

class MyApp < Wx::App
    def on_init
      MapBuilderFrame.new(nil).show
    end
end

MyApp.new.main_loop
