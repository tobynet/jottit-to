# JottitTo
[![Gem Version](https://badge.fury.io/rb/jottit-to.png)](http://badge.fury.io/rb/jottit-to) [![Build Status](https://travis-ci.org/tobynet/jottit-to.svg?branch=master)](https://travis-ci.org/tobynet/jottit-to) [![Dependency Status](https://gemnasium.com/tobynet/jottit-to.png)](https://gemnasium.com/tobynet/jottit-to) [![Code Climate](https://codeclimate.com/github/tobynet/jottit-to.png)](https://codeclimate.com/github/tobynet/jottit-to) [![Coverage Status](https://coveralls.io/repos/tobynet/jottit-to/badge.png?branch=master)](https://coveralls.io/r/tobynet/jottit-to)


Jottit list page converter for CLI

## Installation

    $ gem install jottit-to

## Usage

## As a tool for CLI:

```bash
$ jottit-to json http://youpy.jottit.com/trivia
["Evernoteは象で動いている","CD音質を超えるデータはすべてハイレゾ", ...

$ jottit-to yaml http://youpy.jottit.com/trivia | head
---
- Evernoteは象で動いている
- CD音質を超えるデータはすべてハイレゾ
 :

$ jottit-to text http://youpy.jottit.com/trivia | head
Evernoteは象で動いている
CD音質を超えるデータはすべてハイレゾ
 :

$ jottit-to xml http://youpy.jottit.com/trivia | head
<?xml version="1.0" encoding="UTF-8"?>
<items>
  <item>Evernoteは象で動いている</item>
  <item>CD音質を超えるデータはすべてハイレゾ</item>
 : 
```

## Applications for CLI:


* Fetch random one

    ```bash
    $ jottit-to text http://youpy.jottit.com/trivia | shuf -n 1
    高性能な機械は触ると少しひんやりする
    ```
* Tweet a trivia with usging `tw` gem ( http://shokai.github.io/tw/ )

    ```bash
    $ jottit-to text http://youpy.jottit.com/trivia | shuf -n 1 | tw --pipe
    首をボキボキ鳴らすと1トンの衝撃がかかる
    http://twitter.com/toby_net/status/451337693436198913
    2014-04-02 21:37:46 +0900
    ```

* Tweet a trivia like yazawa using `YAZAWA` gem ( https://github.com/tobynet/yazawa ) and tw

    ```bash
    $ jottit-to text http://youpy.jottit.com/trivia | shuf -n 1 | yazawa | tw --pipe
    『SOUJI』は人を裏切らない
    http://twitter.com/toby_net/status/451338808189911040
    2014-04-02 21:42:12 +0900
    ```

## As a library of ruby:

```ruby
require 'jottit-to'

uri = 'http://youpy.jottit.com/trivia'

puts JottitTo.parse_uri(uri).to_json    # Fetch and print as JSON
puts JottitTo.parse_uri(uri).to_yaml    # Fetch and print as yaml
puts JottitTo.parse_uri(uri).to_text    # Fetch and print as text
puts JottitTo.parse_uri(uri).to_xml     # Fetch and print as xml
```

