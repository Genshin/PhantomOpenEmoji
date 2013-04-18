Phantom Open Emoji
==================
Phantom Open Emoji is a completely free and open source set of emoji.

Get ALL the Emoji! Kickstart us!
--------------------------------
This project is on kickstarter at http://www.kickstarter.com/projects/374397522/phantom-open-emoji .
Without your support the set may not be completed in one go. The more support we have the more complete and better this project will be.

License and Use
---------------

This project is licensed under a combination of the SIL Open Font License, MIT License and the CC 3.0 License [CC-By with attribution requirement waived]. In short you can use everything in this repository however you want. Please see the LICENSE.md file for finer details.

Easy Use as a Gem
-----------------
Install the libaray and command line tool with:

```bash
gem install phantom_open_emoji
```

Or use in a ruby project by adding to your Gemfile
```ruby
gem 'phantom_open_emoji'
```
Converter/Lookup Library and Script
----------------
There is a conversion and lookup library provided in ./lib. poe.rb contains all the actual scripts, and poe-cli in ./bin is a command line wrapper script that can be run from a terminal.

Example:
```bash
poe-cli -s 200 -c
```
*Will output 200px * 200px png files to ./png200
