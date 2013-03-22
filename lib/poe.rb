# -*- encoding: utf-8 -*-

require 'json'
require 'rsvg2'

class POE
  @index

  def initialize
    parse_json_index('./index.json')
  end

  def parse_json_index(file)
    file = open(file).read
    @index = JSON.parse(file)
  end

  def get_index()
    return @index
  end

  def index_to_png(px, outdir)
    @index.each do |item|
      emoji_to_png(item['name'], px, outdir)
    end
  end

  def emoji_to_png(name, px, outdir)
    source = "./images/svg/" + name + ".svg"
    destination = outdir + name + ".png"

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

  # 絵文字から検索
  def lookup_emoji(emoji)
    @index.each do |item|
      if emoji == item['moji']
        return item
      end
    end
  end

  # 名前から検索
  def lookup_name(name)
    @index.each do |item|
      if name == item['name']
        return item
      end
    end
  end

  # 日本語名から検索
  def lookup_name_ja(name_ja)
    @index.each do |item|
      if name_ja == item['name-ja']
        return item
      end
    end
  end

end
