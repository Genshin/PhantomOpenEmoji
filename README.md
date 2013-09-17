Phantom Open Emoji[![Code Climate](https://codeclimate.com/github/Genshin/PhantomOpenEmoji.png)](https://codeclimate.com/github/Genshin/PhantomOpenEmoji)
==================
Phantom Open Emoji is a completely free and open source set of emoji.

POE on Kickstarter
------------------
This project was started from a campaign on kickstarter at http://www.kickstarter.com/projects/374397522/phantom-open-emoji .
Thanks to the support of our backers we've made it this far. We did not however receive enough funding to complete the set, but will attempt to do so with our emoji-as-a-service platform "emojidex".

Emojidex
--------
[emojidex](http://www.emojidex.com) is our emoji-as-a-service site. It includes Phantom Open Emoji as a static base set of emoji.

Contributing to POE
-------------------
Due to copyright issues (as in whatever we did not create we don't own the copyright to) and conflicts of interests with emojidex POE will not be taking direct contributions of graphical assets. If however you would like to contribute to POE and show that you did with the inclusion of a graphic that you made arrangements can be made for its inclusion. Please inquire directly to [info at genshin dot org](mailto:info@genshin.org).

I want an emoji made!
---------------------
OR
--
I want to fund a standard set emoji and get attribution!
--------------------------------------------------------
Radical! You'd better make your order now because once emojidex is fully launched there will be a lockout for POE core. All detals from POE will be preserved and displayed in emojidex.

If you would like to fund a standard set emoji and receive attribution the cost is a flat ￥4,000 (roughly $40USD). The "attribution" tag will include your details, so this a great way to show you supported an open source project. The attribution will of course show up on emojidex in the emoji details as well.

For a fully customized emoji with inclusion in POE prices start from ￥10,000 (roughly $100USD) and you can include a URL along with the attribution tag - effectivly making every use of your emoji into a link.

License and Use
---------------
This project is licensed under a combination of the SIL Open Font License, MIT License and the CC 3.0 License [CC-By with attribution requirement waived]. In short you can use everything in this repository however you want. Please see the LICENSE.md file for finer details.

Easy Use as a Gem
-----------------
Install the library and command line tool with:

```bash
gem install phantom_open_emoji
```

Or use in a ruby project by adding to your Gemfile
```ruby
gem 'phantom_open_emoji'
```

Animated Emoji
--------------
For animated emoji you must have apngasm and it must be somewhere accessable in your path. Without apngasm all animated emoji will simply be exported as the first (static) frame.

Installation on Linux
---------------------
Simple, will write out how if anyone can't figre it out.

Installation on OSX
-------------------
The converter won't work on with HomeBrew due to building rsvg libraries against older system libraries but it does work with MacPorts.

With MacPorts:
```bash
sudo port install imagemagick librsvg gdk-pixbuf2 cairo
```

Converter/Lookup Library and Script
-----------------------------------
There is a conversion and lookup library provided in ./lib. poe.rb contains all the actual scripts, and poe-cli in ./bin is a command line wrapper script that can be run from a terminal.

Example:
```bash
poe-cli -s 200 -c
```
*Will output 200px * 200px png files to ./png200
