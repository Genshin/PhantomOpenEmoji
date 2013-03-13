# -*- encoding: utf-8 -*-

require './poe.rb'

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

poe.parse_json_index('index.json')
