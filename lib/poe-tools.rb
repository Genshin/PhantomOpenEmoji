# -*- encoding: utf-8 -*-


require './poe.rb'
require 'optparse'

poe = POE.new

#TODO
# $ poe-tools -h
# $ poe-tools help
# * print help

#TODO
# $ poe-tools -i {index_file}
# * the -i flag allows specification of an index other than the default

#TODO
# $ poe-tools convert {format} {px}
# E poe-tools convert png 64
# * converts to {format} in {px} size
# - defaults to png when format not specified
# - defaults to 64 when size not specified

# helpを表示
if ARGV[0] == 'help'
  puts 'print help!'
end

# 引数がない場合はindex.jsonを使用
if ARGV[0].nil?
  poe.parse_json_index('index.json')
end

# コンバート
if ARGV[0] == 'convert'
  if ARGV.size < 3
    puts '引数が足りません'
  end

  if ARGV[1] != 'png' && ARGV[1] != 'svg'
    puts '形式が違います'
  end

  if ARGV[2] =~ /[0-9]/
    puts 'ok'
  else
    puts '整数を入力してください'
  end
end

# オプション付き
ARGV.options do |opts|
  # helpを表示
  opts.on("-h", "--help") {|help|
    puts 'print help!'
  }

 # index.json以外のインデックスファイルを使用
  opts.on("-i FILE") {|file|
    puts 'not use index.json!'
    #poe.parse_json_index(file)
  }

  # デフォルト(png 64px)コンバート
  opts.on("-c", "--convert") {|c|
    puts 'default convert!'
    # poe.all_to_png(64)
  }

  opts.parse!
end
