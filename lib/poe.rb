# -*- encoding: utf-8 -*-

require 'json'
require 'rsvg2'

class POE
  @index

  def parse_json_index(file)
    file = open(file).read
    @index = JSON.parse(file)
  end

  def show_items()
    if @index.nil?
      parse_json_index('./index.json')
    end

    @index.each do |item|
      str = ""
      if !(item['moji'].nil?)
        str += item['moji']
      end
      str += "\t"
      if !(item['name'].nil?)
        str += item['name']
      end
      str += "\t"
      if !(item['name-ja'].nil?)
        str += item['name-ja']
      end
      str += "\t"
      if !(item['unicode'].nil?)
        str += item['unicode']
      end
      puts str
    end
  end

  def all_to_png(px)
    if @index.nil?
      parse_json_index('./index.json')
    end

    @index.each do |item|
      emoji_to_png(item['name'], px)
    end
  end

  def emoji_to_png(name, px)
    source = "./images/svg/" + name + ".svg"
    destination = "./images/png64/" + name + ".png"

    handle = RSVG::Handle.new_from_file(source)

    output_px = px

    dim = handle.dimensions
    ratio_w = output_px.to_f / dim.width.to_f
    ratio_h = output_px.to_f / dim.height.to_f

    surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, output_px, output_px)
    context = Cairo::Context.new(surface)
    context.scale(ratio_w, ratio_h)
    context.render_rsvg_handle(handle)
    surface.write_to_png(destination)
  end

  # helpを表示
  def print_help
    str = File.read("help.txt", :encoding => Encoding::UTF_8)
    print(str)
  end

  # 絵文字から名前を検索
  def emoji_to_name(emoji)
    if @index.nil?
      parse_json_index('./index.json')
    end

    @index.each do |item|
      if emoji == item['moji']
        puts item['name']
      end
    end
  end

  # 絵文字から日本語名を検索
  def emoji_to_name_ja(emoji)
    if @index.nil?
      parse_json_index('./index.json')
    end

    @index.each do |item|
      if emoji == item['moji']
        puts item['name-ja']
      end
    end
  end

  # 名前から絵文字を検索
  def name_to_emoji(name)
    if @index.nil?
      parse_json_index('./index.json')
    end

    @index.each do |item|
      if name == item['name']
        puts item['moji']
      end
    end
  end

  # 日本語名から絵文字を検索
  def name_ja_to_emoji(name_ja)
    if @index.nil?
      parse_json_index('./index.json')
    end

    @index.each do |item|
      if name_ja == item['name-ja']
        puts item['moji']
      end
    end
  end

end