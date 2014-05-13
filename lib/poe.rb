# -*- encoding: utf-8 -*-

require 'json'
require 'rsvg2'
require 'fileutils'
require 'RMagick'

class POE
  attr_accessor :index, :source_path, :format, :px, :target_path,
    :has_apng_support, :unicode_only, :category_names, :categorized_index,
    :output_json, :output_index, :output_filename, :raw_output

  DEF_PX = 64
  DEF_FORMAT = 'png'
  DEF_TARGET = './images/' + DEF_FORMAT + DEF_PX.to_s + '/'

  def _check_system_deps()
    # apngasm
    `which apngasm`
    @has_apng_support = $?.success?
  end

  def initialize
    # use the standard index inside lib
    @source_path = File.expand_path('../../', __FILE__)
    set_index_file(@source_path + '/app/assets/javascripts/poe/index.json')

    set_category_names()
    set_categorized_index()

    _check_system_deps()

    @px = DEF_PX
    @format = DEF_FORMAT
    @unicode_only = false
    @output_json = false
    @output_index = Array.new
  end

  def get_index()
    return @index
  end

  def set_index_file(file)
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

  def set_unicode_only(flag)
    @unicode_only = flag    # flag is true
  end

  def convert_index()
    create_target_path()

    case @format
    when 'png'
      @index.each do |emoji|
        if @unicode_only && emoji['unicode'] != nil
          convert_emoji(emoji)
          create_unicode_symlink(emoji)
          set_output_index(emoji)  
        elsif !@unicode_only
          convert_emoji(emoji)
          create_unicode_symlink(emoji)
          set_output_index(emoji)
        end
      end
    end

    output_json_file() if @output_json
  end

  def get_source_info(emoji)
    path = @source_path + '/app/assets/images/poe/svg/' + emoji['name']

    if File.exist?(path + '.svg') # SVG source file
      return {:file => path + '.svg', :type => 'svg'}
    elsif FileTest.exist?(path) # folder with multiple sources for animation
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
    else # No apng generation. Fallback.
      FileUtils.cp(frame_path + '0.png', @target_path + name + '.png')
    end
  end

  def convert_emoji(emoji)
    source = get_source_info(emoji)

    case source[:type]
    when 'svg'
      if @raw_output
        create_target_path()
        FileUtils.cp(source[:file], @target_path)
      else
        surface = _svg_to_surface(source[:file])
        create_target_path()
        surface.write_to_png(@target_path + emoji['name'] + '.png')
      end
    when 'directory'
      origin = Dir.pwd
      Dir.chdir(source[:path])

      if @raw_output
        frame_path = @target_path + emoji['name'] + '/'
        create_target_path(frame_path, false)
        animation_info = JSON.parse(open(source[:path] + 'animation.json').read)
        FileUtils::cp(source[:path] + 'animation.json', frame_path)
        animation_info['order'].each_with_index do |number, i|
          FileUtils::cp(source[:path] + number.to_s + '.svg', frame_path)
        end
      else
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
      end

      _generate_apng(frame_path, emoji['name'], animation_info)

      Dir.chdir(origin)
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

  def create_unicode_symlink(emoji)
    origin = Dir.pwd
    Dir.chdir(@target_path)

    origin_path = '../' + emoji['name'] + '.png'
    symlink_path = './' + 'unicode/' + emoji['unicode'] + '.png' unless emoji['unicode'].nil?

    unless FileTest.exist?( './unicode')
      Dir::mkdir('./unicode')
    end

    unless emoji['unicode'].nil?
      FileUtils.symlink(origin_path, symlink_path, {force: true})
    end

    Dir.chdir(origin)
  end

  def set_output_json(flag)
    @output_json = flag   # flag is true
  end

  def set_output_index(emoji)    
    @output_index << emoji
  end

  def set_output_filename(filename)
    @output_filename = filename
  end

  def output_json_file
    File.open(@output_filename + '.json', 'w') do |io|
      io.write JSON.pretty_generate @output_index
    end
  end

  def lookup_character(character)
    @index.each do |item|
      if character == item['moji']
        return item
      end
    end
    return nil
  end

  def lookup_name(name)
    @index.each do |item|
      if name == item['name']
        return item
      end
    end
    return nil
  end

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

  def set_category_names()
    @category_names = Array.new
    @index.each do |item|
      @category_names << item['category'] unless @category_names.include?(item['category'])
    end
  end

  def category_names()
    return @category_names
  end

  def set_categorized_index()
    @categorized_index = Hash.new
    @category_names.each do |name|
      @categorized_index.store(name, nil)
      tmp = Array.new
      @index.each do |item|
        tmp << item['name'] if (item['category'] == name)
      end
      @categorized_index[name] = tmp
    end
  end

  def categorized_index()
    return @categorized_index
  end
end
