#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$VERBOSE = true
require 'minitest/autorun'
begin require 'minitest/pride' rescue LoadError end # Ignore error for old ruby

require 'webmock/minitest'

require_relative '../lib/jottit-to'

describe JottitTo do
  it 'can get normalized uri' do
    test_uris = [
      {
        src: 'http://youpy.jottit.com/trivia?m=diff&r=525&r=526#fuba',
        expected: 'http://youpy.jottit.com/trivia'
      },
      {
        src: 'http://youpy.jottit.com/trivia#fuba', 
        expected: 'http://youpy.jottit.com/trivia'
      },
      {
        src: 'http://youpy.jottit.com/#aaa', 
        expected: 'http://youpy.jottit.com/'
      },
      {
        src: 'http://youpy.jottit.com/trivia', 
        expected: 'http://youpy.jottit.com/trivia'
      }
    ]
    test_uris.each do |data|
      JottitTo.normalize_uri(data[:src]).must_equal data[:expected]
    end
  end

  def html_of_fixture
    #raw_html = URI('http://youpy.jottit.com/trivia').read
    File.read(File.join(File.dirname(__FILE__), './fixture.html'))
  end

  it 'can parse a structure like a site of jottit' do
    items = JottitTo.parse_html(html_of_fixture)
    items.must_equal %w(foo bar buzz piyo)
  end

  it 'can parse with uri' do
    # make stub with webmock
    stub_request(:get, 'www.example.com').to_return(body: html_of_fixture)

    items = JottitTo.parse_uri('http://www.example.com/')
    items.must_equal %w(foo bar buzz piyo)
  end

end

describe JottitTo::ArrayExtender do
  it 'can convert self to xml' do
    test_items = [
      {
        src: %w(foo bar buzz piyo), 
        expected: <<-EOD
<?xml version="1.0" encoding="UTF-8"?>
<items>
  <item>foo</item>
  <item>bar</item>
  <item>buzz</item>
  <item>piyo</item>
</items>
        EOD
      },
      {
        src: [], 
        expected: <<-EOD
<?xml version="1.0" encoding="UTF-8"?>
<items>
</items>
        EOD
      }
    ]

    test_items.each do |item|
      list = item[:src].dup
      list.extend JottitTo::ArrayExtender
      list.to_xml.must_equal item[:expected]
    end
  end

  it 'can convert self to text' do
    test_items = [
      {
        src: %w(foo bar buzz piyo), 
        expected: <<-EOD.chomp
foo
bar
buzz
piyo
        EOD
      },
      {
        src: [], 
        expected: ''
      }
    ]

    test_items.each do |item|
      list = item[:src].dup
      list.extend JottitTo::ArrayExtender
      list.to_text.must_equal item[:expected]
    end
  end
  
  it 'can convert self to json' do
    test_items = [
      {
        src: %w(foo bar buzz piyo), 
        expected: '["foo","bar","buzz","piyo"]'
      },
      {
        src: [], 
        expected: '[]'
      }
    ]

    test_items.each do |item|
      list = item[:src].dup
      list.extend JottitTo::ArrayExtender
      list.to_json.must_equal item[:expected]
    end
  end

  it 'can convert self to yaml' do
    test_items = [
      {
        src: %w(foo bar buzz piyo), 
        expected: <<-EOD
---
- foo
- bar
- buzz
- piyo
        EOD
      },
      {
        src: [], 
        expected: "--- []\n"
      }
    ]

    test_items.each do |item|
      list = item[:src].dup
      list.extend JottitTo::ArrayExtender
      list.to_yaml.must_equal item[:expected]
    end
  end
end

describe 'bin/' do
  it 'works run(help)' do
    io = IO.popen([File.join(File.dirname(__FILE__), '../bin/jottit-to'), err: [:child, :out]])
    io.read.must_match(/Commands:/)
  end
end

