# -*- encoding: utf-8 -*-

require './poe.rb'
require 'optparse'

poe = POE.new

#TODO
# $ poe-tools convert {format} {px}
# E poe-tools convert png 64
# * converts to {format} in {px} size
# - defaults to png when format not specified
# - defaults to 64 when size not specified

# helpを表示
if ARGV[0] == 'help'
  puts poe.print_help
end

opts = OptionParser.new
# ヘルプ
opts.on('-h', '--help') {|v|
  poe.print_help
}
# index.json以外のファイル使用
opts.on('-i=FILE') {|v|
  poe.parse_json_index(v)
}
# コンバート
opts.on('-c=FORMAT PX', '--convert=FORMAT PX') {|v|
  puts v
  puts ARGV[0]
}
# 絵文字から名前を検索
opts.on('--search-name=EMOJI') {|v|
  poe.emoji_to_name(v)
}
# 絵文字から日本語名を検索
opts.on('--search-name-ja=EMOJI') {|v|
  poe.emoji_to_name_ja(v)
}
# 名前から絵文字を検索
opts.on('--search-emoji-name=NAME') {|v|
  poe.name_to_emoji(v)
}
# 日本語名から絵文字を検索
opts.on('--search-emoji-name-ja=NAME') {|v|
  poe.name_ja_to_emoji(v)
}
opts.parse!(ARGV)

=begin
# オプション
ARGV.options do |opts|
  # helpを表示
  opts.on("-h", "--help") {|help|
    poe.print_help
  }

 # index.json以外のインデックスファイルを使用
  opts.on("-i=FILE") {|file|
    poe.parse_json_index(file)
  }

  # コンバート
  opts.on("-c=FORMAT PX", "--convert=FORMAT PX") {|c|
    format = c
    px = ARGV
    # poe.all_to_png(64)
  }

  opts.parse!
end
=end

=begin
# 引数がない場合はindex.jsonを使用
if ARGV[0].nil?
  poe.parse_json_index('index.json')
end
=end

# コンバート
=begin
if ARGV[0] == 'convert'
  if ARGV.size == 1 then
    puts 'default convert!'
  elsif ARGV[1] != 'png' && ARGV[1] != 'svg' then
    puts 'error: poe-tools convert {format} {px}   ex) poe-tools convert png 64'
  elsif !ARGV[2] =~ /[0-9]/ then
    puts 'error: poe-tools convert {format} {px}   ex) poe-tools convert png 64'
  else
     puts ARGV[1] + ' ' + ARGV[2] + ' convert!'
  end
end
=end

# コンバート
for num in 0..ARGV.size do
  if ARGV[num] == 'convert' then
    if ARGV[num + 1] != 'png' && ARGV[num + 1] != 'svg' then
      puts 'error: poe-tools convert {format} {px}   ex) poe-tools convert png 64'
    elsif !(ARGV[num + 2] =~ /[0-9]/) then
      puts 'error: poe-tools convert {format} {px}   ex) poe-tools convert png 64'
    else
      format = ARGV[num + 1]
      px = ARGV[num + 2]
      puts ARGV[num] + ' ' + format + ' ' + px
    end
  end
end