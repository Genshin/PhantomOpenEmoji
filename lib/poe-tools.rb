# -*- encoding: utf-8 -*-

require 'json'
#require 'rsvg2'

#rsvg-convert -w 200 smile_only.svg -o testes.png

=begin ===========================================================================
SRC = "./images/svg/smile_only.svg"
DST = "smile_only.png"

handle = RSVG::Handle.new_from_file(SRC)

ratio = 1.0

output_px = 128

dim = handle.dimensions
ratio_w = output_px.to_f / dim.width.to_f
ratio_h = output_px.to_f / dim.height.to_f

surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, output_px, output_px)
context = Cairo::Context.new(surface)
context.scale(ratio_w, ratio_h)
context.render_rsvg_handle(handle)
surface.write_to_png(DST)
=end ===========================================================================

# #File.open('index.json", r
#
# #"images/svg/???.svg" -> "images/png64/???.png"

emojiDatas = Array.new

file = open('index.json').read
data = JSON.parse(file)
data.each do |list|
  emojiDatas.push(list)
end

emojiDatas.each do |emoji|
  # ここでコンバートとか
  # 'images/svg/' + emoji['name'] + '.svg'
  # 'images/png64/' + emoji['name'] + '.png'
  puts 'images/svg/' + emoji['name'] + '.svg'
end