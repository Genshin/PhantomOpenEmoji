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
# helpを表示
opts.on('-h', '--help') {|v|
  poe.print_help
}
# 一覧表示
opts.on('-l') {|v|
  poe.show_items
}
# ./index.json以外のファイル使用
opts.on('-i=FILE') {|v|
  poe.parse_json_index(v)
}
# コンバート
opts.on('-c=FORMAT PX', '--convert=FORMAT PX') {|v|
  if ARGV[0].nil?
    puts 'error'
  elsif v == 'png'
    poe.all_to_png(ARGV[0])
  end
  # 将来的にフォーマットが増える？
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

# コンバート
for num in 0..ARGV.size do
  if ARGV[num] == 'convert' then
    if num == ARGV.size - 1 then
      # デフォルトのコンバート
      poe.all_to_png(64)
      # puts 'default'
      break
    elsif ARGV[num + 1] != 'png' && ARGV[num + 1] != 'gif' then
      # {format}が違う
      puts 'error: poe-tools convert {format} {px}   ex) poe-tools convert png 64'
      break
    elsif !(ARGV[num + 2] =~ /[0-9]/)  || ARGV[num + 2].nil? then
      # {px}が違う
      puts 'error: poe-tools convert {format} {px}   ex) poe-tools convert png 64'
      break
    else
      if ARGV[num + 1] == 'png'
        poe.all_to_png(ARGV[num + 2])
        # puts 'png' + ARGV[num + 2]
      end
      # 将来的に違うフォーマットも増える？
      break
    end
  end
end