# -*- encoding: utf-8 -*-

require 'json'
require 'rsvg2'
require 'fileutils'

class POE
  @index
  @source_path
  @format
  @px
  @outdir

  DEF_PX = 64
  DEF_FORMAT = 'png'
  DEF_OUTDIR = "./images"

  def initialize
    @source_path = File.expand_path('../', __FILE__)
    parse_json_index(@source_path + "index.json")
  end

  def parse_json_index(file)
    file = open(file).read
    @index = JSON.parse(file)
  end

  def get_index()
    return @index
  end

  def convert_index(format, px, outdir, outdir_is_absolute = false)
    @format = format
    if @format.nil?
      @format = DEF_FORMAT
    end

    @px = px
    if @px.nil?
      @px = DEF_PX
    end

    @outdir = outdir
    if @outdir.nil?
      @outdir = DEF_OUTDIR
    end

    destination = create_destination(@outdir, @format, @px, outdir_is_absolute)

    case @format
    when 'png'
      index_to_png(@px, destination)
    end

  end

  def index_to_png(px, destination)
    #TODO handle outdir
    @index.each do |item|
      emoji_to_png(item['name'], px, destination)
    end
  end

  def emoji_to_png(name, px, destination)
    source = "./images/svg/" + name + ".svg"

    puts "CONVERTING: " + name + " @ " + px.to_s + "px"

    handle = RSVG::Handle.new_from_file(source)

    output_px = px

    dim = handle.dimensions
    ratio_w = output_px.to_f / dim.width.to_f
    ratio_h = output_px.to_f / dim.height.to_f

    surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, output_px, output_px)
    context = Cairo::Context.new(surface)
    context.scale(ratio_w, ratio_h)
    context.render_rsvg_handle(handle)
    surface.write_to_png(destination + "/" + name + ".png")
  end

  def create_destination(outdir, format, px, outdir_is_absolute = false)
    if outdir_is_absolute
      destination = outdir
    else
      destination = outdir + "/" + format + px.to_s
    end

    begin
      Dir::mkdir(destination)
      Dir::mkdir(destination + "/unicode")
    rescue
    end

    return destination
  end

  # シンボリックリンク作成
  def create_unicode_symlink(emoji, srcdir, outdir)
    if !emoji.unicode.nil?
      putf "moji " + item.name + " unicode " + item.unicode
    end

   # FileUtils.mkdir_p(outdir) unless FileTest.exist?(outdir)
   # Dir.chdir(pngdir)
   # filenames = Dir.glob('*.png')
   # filenames.each do |f|
   #FileUtils.symlink( "./" + srcdir + '/' + emoji.name + , fullpath + '/' + outdir + '/' + f, {:force => true});
   # end
  end

  # 絵文字から検索
  def lookup_emoji(emoji)
    @index.each do |item|
      if emoji == item['moji']
        return item
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

