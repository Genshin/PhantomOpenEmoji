#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require './poe.rb'
require 'optparse'

@poe = POE.new
@format = 'png'
@size = 64
@outdir = "./images/png64/"

def list_emoji()
  index = @poe.get_index

  index.each do |item|
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


opts = OptionParser.new
# 一覧表示
opts.on('-l', '--list') {|v|
  list_emoji
}

# ./index.json以外のファイル使用
opts.on('-i', '--index') {|index_file|
  @poe.parse_json_index(index_file)
}

opts.on('-f FORMAT', '--format FORMAT') {|format|
  @format = format
}

opts.on('-s PX', '--size PX') {|px|
  @size = px
}

# コンバート
opts.on('-c [OUTDIR]', '--convert [OUTDIR]') {|outdir|
  if !outdir.nil?
    @outdir = outdir
  end
  if @format == 'png'
    @poe.index_to_png(@size, @outdir)
  end
}

# 絵文字から検索
opts.on('--lookup-emoji EMOJI') {|emoji|
  puts @poe.lookup_emoji(emoji)
}
# 名前から検索
opts.on('--lookup-name NAME') {|name|
  puts @poe.lookup_name(name)
}
# 日本語名から絵文字を検索
opts.on('--lookup-name-ja NAME') {|name|
  puts @poe.lookup_name_ja(name)
}

# for num in 0..ARGV.size do
#   if ARGV[num] == 'convert' then
#     if num == ARGV.size - 1 then
#       # デフォルトのコンバート
#       poe.all_to_png(64)
#       # puts 'default'
#       break
#     elsif ARGV[num + 1] != 'png' && ARGV[num + 1] != 'gif' then
#       # {format}が違う
#       puts 'error: poe-tools convert {format} {px}   ex) poe-tools convert png 64'
#       break
#     elsif !(ARGV[num + 2] =~ /[0-9]/)  || ARGV[num + 2].nil? then
#       # {px}が違う
#       puts 'error: poe-tools convert {format} {px}   ex) poe-tools convert png 64'
#       break
#     else
#       if ARGV[num + 1] == 'png'
#         poe.all_to_png(ARGV[num + 2].to_i)
#         # puts 'png' + ARGV[num + 2]
#       end
#       # 将来的に違うフォーマットも増える？
#       break
#     end
#   end
# end
opts.parse!(ARGV)
