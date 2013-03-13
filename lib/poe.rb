# -*- encoding: utf-8 -*-

require 'json'
require 'rsvg2'



class POE
  @index

  def parse_json_index(file)
    filenames = Array.new

    file = open('index.json').read
    @index = JSON.parse(file)
    @index.each do |item|
      puts item['moji']
      puts item['name']
      puts item['name-ja']
      puts item['unicode']
      filename = 'images/svg/' + item['name'] + '.svg'
      filenames.push(filename)
    end

    filenames.each do |name|
      puts name
      # ここでコンバートとか…？
    end
  end

  def all_to_png(px)
  end

  def emoji_to_png(name, px)
    source = "./images/svg/smile_only.svg"
    destination = "smile_only.png"

    handle = RSVG::Handle.new_from_file(source)

    output_px = 128

    dim = handle.dimensions
    ratio_w = output_px.to_f / dim.width.to_f
    ratio_h = output_px.to_f / dim.height.to_f

    surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, output_px, output_px)
    context = Cairo::Context.new(surface)
    context.scale(ratio_w, ratio_h)
    context.render_rsvg_handle(handle)
    surface.write_to_png(destination)
  end

end


