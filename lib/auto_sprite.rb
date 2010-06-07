require 'RMagick'
require 'fileutils'

module AutoSprite
  SPRITE_ASSETS_PATH = File.join(RAILS_ROOT, 'public', 'images',      'sprites')
  CSS_FILE_PATH      = File.join(RAILS_ROOT, 'public', 'stylesheets', 'auto_sprite.css')
  SPRITE_IMG_PATH    = File.join(RAILS_ROOT, 'public', 'images',      'auto_sprite.png')
  SPRITE_IMG_URL     = '/images/auto_sprite.png'

  class << self
    def sprite_file_paths
      @sprite_file_paths ||= sprite_file_names.map {|f| File.join(SPRITE_ASSETS_PATH, f) }
    end

    def sprite_file_names
      @sprite_file_names ||= Dir.entries(SPRITE_ASSETS_PATH).reject { |f| 
        !File.file?(File.join(SPRITE_ASSETS_PATH,f))
      }
    end

    def generate_css_name(f)
      filename = File.basename(f).gsub(/\?.*$/, "")
      filename.tr!('.', "_")
      "_as_#{filename}"
    end

    def stale?
      to_check = [sprite_file_paths , SPRITE_ASSETS_PATH].flatten
      !FileUtils.uptodate?(SPRITE_IMG_PATH , to_check) ||
      !FileUtils.uptodate?(CSS_FILE_PATH   , to_check)    
    end

    def setup!
      FileUtils::mkdir_p(SPRITE_ASSETS_PATH)
      if stale?      
        FileUtils::rm_f(CSS_FILE_PATH)   
        FileUtils::rm_f(SPRITE_IMG_PATH)
        write_new_assets
      end
    end

    def write_new_assets
      unless sprite_file_paths.empty?
        image_list = Magick::ImageList.new(*sprite_file_paths)
        image_list.append(true).write(SPRITE_IMG_PATH)
        all_class_names = sprite_file_names.map { |x| '.' + generate_css_name(x) }
        pos = 0
        File.open(CSS_FILE_PATH, "w") do |f|
          image_list.each do |img|
            css_class = generate_css_name(img.filename)
            f << ".#{css_class}{background-position:0 #{pos * -1}px;height:#{img.rows}px;width:#{img.columns}px;}"
            pos = pos + img.rows;
          end
          f << all_class_names.join(",")
          f << "{display:inline-block;background-image:url('#{SPRITE_IMG_URL}?#{File.mtime(SPRITE_IMG_PATH).to_i}');background-repeat:no-repeat;}"
        end
      end
    end
  end
end


module AutoSprite::Helpers 
  def self.included(base)
    base.class_eval do
      def image_tag(source, options = {})
        src = path_to_image(source)
        if src =~ /\/images\/sprites/
          content_tag :span, '', options.merge(:class => AutoSprite.generate_css_name(src))
        else
          super(source,options)
        end
      end
    end
  end
end
