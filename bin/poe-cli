#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require File.expand_path('../../lib/poe.rb', __FILE__)
require 'optparse'

@poe = POE.new

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
  @poe.set_index_file(index_file)
}

opts.on('-f FORMAT', '--format FORMAT') {|format|
  @poe.set_format(format)
}

opts.on('-s PX', '--size PX') {|px|
  @poe.set_size(px.to_i)
}

# コンバート
opts.on('-c [OUTDIR]', '--convert [OUTDIR]') {|outdir|
  if outdir.nil?
    @poe.set_target_path(Dir.pwd, true)
  else
    @poe.set_target_path(outdir, false)
  end

  @poe.convert_index()
}

def convert_standard_sets
  @poe.set_format 'png'

  @poe.set_size(20)
  @poe.set_target_path(Dir.pwd, true)
  @poe.convert_index()

  @poe.set_size(64)
  @poe.set_target_path(Dir.pwd, true)
  @poe.convert_index()
end

opts.on('--standard') {
  convert_standard_sets
}

def convert_android_sets
  @poe.set_format 'png'

  @poe.set_size(9)
  @poe.set_target_path(Dir.pwd + '/drawable-ldpi')
  @poe.convert_index()

  @poe.set_size(18)
  @poe.set_target_path(Dir.pwd + '/drawable-mdpi')
  @poe.convert_index()

  @poe.set_size(27)
  @poe.set_target_path(Dir.pwd + '/drawable-hdpi')
  @poe.convert_index()

  @poe.set_size(36)
  @poe.set_target_path(Dir.pwd + '/drawable-xhdpi')
  @poe.convert_index()
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
