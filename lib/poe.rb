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

  DEF_PX = 64
  DEF_FORMAT = 'png'
  DEF_TARGET = './images/' + DEF_FORMAT + DEF_PX.to_s + '/'

  def initialize
    #use the standard index inside lib
    @source_path = File.expand_path('../', __FILE__)
    set_index_file(@source_path + '/index.json')

    @px = DEF_PX
    @format = DEF_FORMAT
  end

  def get_index()
    return @index
  end

  def set_index_file(file)
    @source_path = File.expand_path('../', file)
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
        emoji_to_png(emoji)
      end
    end
  end

  def get_source_info(emoji)
    path = @source_path + '/images/svg/' + emoji['name']
    if File.exist?(path + '.svg') #SVG source file
      return {file: path + '.svg', type: 'svg'}
    elsif FileTest.exist?(path) #folder with multiple sources for animation
      files = Dir.entries(path)
      return {path: path + "/", files: files, type: 'directory'}
    end

    return {path: path, type: 'none'}
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

  def emoji_to_png(emoji)
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
      Dir['*.svg'].each do |source_file|
        surface = _svg_to_surface(source_file)
        frame = Magick::Image.new(@px, @px)
        frame.import_pixels(0, 0, @px, @px, 'BGRA', surface.data)
        animation << frame
      end

      Dir.chdir(origin)

      animation.delay = 10
      animation.write(@target_path + emoji['name'] + ".miff")
    end
  end

  def create_target_path()
    if FileTest.exist?(@target_path)
      return true
    end

    begin
      Dir::mkdir(@target_path)
      Dir::mkdir(@target_path + 'unicode')
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

