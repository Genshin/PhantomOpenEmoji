#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require './poe.rb'
require 'optparse'

@poe = POE.new
@format = 'png'
@size = 64
@outdir = "./images"
@pngdir = 'images/png64'

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
opts.on('--list', '-l') {
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

def convert_standard_sets
  @poe.convert_index('png', 20, @outdir)
  @poe.convert_index('png', 64, @outdir)
end

opts.on('--standard') {
  convert_standard_sets
}

def convert_android_sets
  @poe.convert_index('png', 9, @outdir + '/drawable-ldpi', true)
  @poe.convert_index('png', 18, @outdir + '/drawable-mdpi', true)
  @poe.convert_index('png', 27, @outdir + '/drawable-hdpi', true)
  @poe.convert_index('png', 36, @outdir + '/drawable-xhdpi', true)
end

opts.on('--android') {
  convert_android_sets
}

opts.on('--all-sets') {
  convert_standard_sets
  convert_android_sets
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
