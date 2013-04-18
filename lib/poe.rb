# -*- encoding: utf-8 -*-

require 'json'
require 'rsvg2'
require 'fileutils'

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

  def emoji_to_png(emoji)
    source = @source_path + "/images/svg/" + emoji['name'] + ".svg"

    handle = RSVG::Handle.new_from_file(source)

    dim = handle.dimensions
    ratio_w = @px.to_f / dim.width.to_f
    ratio_h = @px.to_f / dim.height.to_f

    surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, @px, @px)
    context = Cairo::Context.new(surface)
    context.scale(ratio_w, ratio_h)
    context.render_rsvg_handle(handle)
    surface.write_to_png(@target_path + emoji['name'] + ".png")
  end

  def create_target_path()
    begin
      Dir::mkdir(@target_path)
      Dir::mkdir(@target_path + "unicode")
    rescue
    end
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

