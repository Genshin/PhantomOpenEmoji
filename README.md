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

Converter/Lookup Library and Script
----------------
There is a conversion and lookup library provided in ./lib. poe.rb contains all the actual scripts, and poe-tools.rb is a command line wrapper script that can be run from a terminal.

Example:
```bash
ruby poe-tools.rb -s 200 -c
```
*Will output 200px * 200px png files to ./lib/images/png200
