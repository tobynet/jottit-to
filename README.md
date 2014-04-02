# JottitTo

Jottit list page converter for CLI

## Installation

    $ gem install jottit-to

## Usage

As a tool for CLI

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

As a library of ruby

```ruby
require 'jottit-to'

uri = 'http://youpy.jottit.com/trivia'

puts JottitTo.parse_uri(uri).to_json    # Fetch and print as JSON
puts JottitTo.parse_uri(uri).to_yaml    # Fetch and print as yaml
puts JottitTo.parse_uri(uri).to_text    # Fetch and print as text
puts JottitTo.parse_uri(uri).to_xml     # Fetch and print as xml
```

