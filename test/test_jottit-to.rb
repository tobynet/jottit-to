#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$VERBOSE = true
require 'minitest/autorun'
begin require 'minitest/pride' rescue LoadError end # Ignore error for old ruby


require_relative '../lib/jottit-to'

describe JottitTo do
  it 'can get normalized uri' do
    test_uris = [
      {
        src: 'http://youpy.jottit.com/trivia?m=diff&r=525&r=526#fuba',
        success: 'http://youpy.jottit.com/trivia'
      },
      {
        src: 'http://youpy.jottit.com/trivia#fuba', 
        success: 'http://youpy.jottit.com/trivia'
      },
      {
        src: 'http://youpy.jottit.com/#aaa', 
        success: 'http://youpy.jottit.com/'
      },
      {
        src: 'http://youpy.jottit.com/trivia', 
        success: 'http://youpy.jottit.com/trivia'
      }
    ]
    test_uris.each do |data|
      JottitTo.normalize_uri(data[:src]).must_equal data[:success]
    end
  end

  it 'can parse a structure like a site of jottit' do
    #raw_html = URI('http://youpy.jottit.com/trivia').read
    raw_html = File.read(File.join(File.dirname(__FILE__), './fixture.html'))
    items = JottitTo.parse_html(raw_html)
    items.must_equal %w(foo bar buzz piyo)
  end

end
