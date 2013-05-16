# -*- encoding: utf-8 -*-

require 'json'
require 'rsvg2'
require 'fileutils'
require 'RMagick'

class POE
  @index #index hash
  @source_path #index.json will be at the root of this path
  @format #defaults to png
  @px #output px
  @target_path #path to output
  @has_apng_support

  DEF_PX = 64
  DEF_FORMAT = 'png'
  DEF_TARGET = './images/' + DEF_FORMAT + DEF_PX.to_s + '/'

  def _check_system_deps()
    #apngasm
    `which apngasm`
    @has_apng_support = $?.success?
  end

  def initialize
    #use the standard index inside lib
    @source_path = File.expand_path('../../', __FILE__)
    set_index_file(@source_path + '/app/assets/javascripts/poe/index.json')

    _check_system_deps()

    @px = DEF_PX
    @format = DEF_FORMAT
  end

  def get_index()
    return @index
  end

  def set_index_file(file)
    #@source_path = File.expand_path('../', file)
    file = open(file).read
    @index = JSON.parse(file)
  end

  def get_target_path()
    return @target_path
  end

  def set_target_path(path, append_format_px = false)
    @target_path = path += '/'
    if append_format_px
      @target_path += '/' + @format + @px.to_s + '/'
    end
  end

  def set_size(px)
    @px = px
  end

  def set_format(format)
    @format = format
  end

  def convert_index()
    create_target_path()

    case @format
    when 'png'
      @index.each do |emoji|
        convert_emoji(emoji)
      end
    end
  end

  def get_source_info(emoji)
    path = @source_path + '/app/assets/images/poe/svg/' + emoji['name']

    if File.exist?(path + '.svg') #SVG source file
      return {:file => path + '.svg', :type => 'svg'}
    elsif FileTest.exist?(path) #folder with multiple sources for animation
      files = Dir.entries(path)
      return {:path => path + "/", :files => files, :type => 'directory'}
    end
    return {:path => path, :type => 'none'}
  end

  def _svg_to_surface(file)
    handle = RSVG::Handle.new_from_file(file)

    dim = handle.dimensions
    ratio_w = @px.to_f / dim.width.to_f
    ratio_h = @px.to_f / dim.height.to_f

    surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, @px, @px)
    context = Cairo::Context.new(surface)
    context.scale(ratio_w, ratio_h)
    context.render_rsvg_handle(handle)

    return surface
  end

  def _generate_apng(frame_path, name, animation_info)
    if @has_apng_support
      `apngasm #{(@target_path + name + '.png')} #{frame_path + '*.png'} #{animation_info['delay'].to_s}`
    else #No apng generation. Fallback.
      FileUtils.cp(frame_path + '0.png', @target_path + name + '.png')
    end
  end

  def convert_emoji(emoji)
    source = get_source_info(emoji)

    case source[:type]
    when 'svg'
      surface = _svg_to_surface(source[:file])
      create_target_path()
      surface.write_to_png(@target_path + emoji['name'] + '.png')
    when 'directory'
      origin = Dir.pwd
      Dir.chdir(source[:path])

      animation = Magick::ImageList.new()
      frame_path = @target_path + emoji['name'] + '/'
      create_target_path(frame_path, false)
      animation_info = JSON.parse(open(source[:path] + 'animation.json').read)
      animation_info['order'].each_with_index do |number, i|
        surface = _svg_to_surface(number.to_s + '.svg')
        surface.write_to_png(frame_path + i.to_s + '.png')
        frame = Magick::Image.new(@px, @px)
        frame.import_pixels(0, 0, @px, @px, 'BGRA', surface.data)
        animation << frame
      end

      _generate_apng(frame_path, emoji['name'], animation_info)

      Dir.chdir(origin)

      #animation.delay = animation_info['delay']
      #opt = animation.optimize_layers(Magick::OptimizeTransLayer)
      #opt.write(@target_path + emoji['name'] + ".mng")
      #opt.write(@target_path + emoji['name'] + ".gif")
    end
  end

  def create_target_path(path = nil, generate_unicode_links = true)
    if path.nil?
      path = @target_path
    end

    if FileTest.exist?(path)
      return true
    end

    begin
      Dir::mkdir(path)
      if generate_unicode_folder
        Dir::mkdir(path + 'unicode')
      end
      return true
    rescue
      return false
    end

    return false
  end

  # シンボリックリンク作成
  def create_unicode_symlink(emoji)
    #if !emoji.unicode.nil?
    #  putf "moji " + item.name + " unicode " + item.unicode
    #end

   # FileUtils.mkdir_p(outdir) unless FileTest.exist?(outdir)
   # Dir.chdir(pngdir)
   # filenames = Dir.glob('*.png')
   # filenames.each do |f|
   #FileUtils.symlink( "./" + srcdir + '/' + emoji.name + , fullpath + '/' + outdir + '/' + f, {:force => true});
   # end
  end

  # 絵文字から検索
  def lookup_character(character)
    @index.each do |emoji|
      if character == emoji['moji']
        return emoji
      end
    end
    return nil
  end

  # 名前から検索
  def lookup_name(name)
    @index.each do |item|
      if name == item['name']
        return item
      end
    end
    return nil
  end

  # 日本語名から検索
  def lookup_name_ja(name_ja)
    @index.each do |item|
      if name_ja == item['name-ja']
        return item
      end
    end
    return nil
  end

  def lookup_emoticon(emoticon)
    @index.each do |item|
      if item.emoticon.exists? && item.emoticon == emoticon
        return item
      end
    end
    return nil
  end

end
