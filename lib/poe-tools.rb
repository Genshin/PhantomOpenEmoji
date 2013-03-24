#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require './poe.rb'
require 'optparse'

@poe = POE.new
@format = 'png'
@size = 64
@outdir = "./images"

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
opts.on('--list', '-l') {|v|
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
  @size = px.to_i
}

# コンバート
opts.on('-c [OUTDIR]', '--convert [OUTDIR]') {|outdir|
  if !outdir.nil?
    @outdir = outdir
  end

  @poe.convert_index(@format, @size, @outdir)
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

opts.parse!(ARGV)

