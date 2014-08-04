#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'

# For colorful testing
begin
  require 'minitest/pride'
rescue LoadError
  # Ignore an error for old ruby
end if $stdout.isatty

require 'webmock/minitest'
require 'yaml'

require_relative '../lib/jottit-to'

def html_of_fixture
  # raw_html = URI('http://youpy.jottit.com/trivia').read
  File.read(File.join(File.dirname(__FILE__), './fixture.html'))
end

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

def fixtures
  @yaml ||= YAML.load File.read(
    File.join(File.dirname(__FILE__), './fixture-array-extender.yaml'))

  @yaml.map do |item|
    array = item['src'].dup
    array.extend(JottitTo::ArrayExtender)
    [item, array]
  end
end

describe JottitTo::ArrayExtender do
  fixtures.each do |item, array|
    it 'can convert self to xml' do
      array.to_xml.must_equal item['expected_as_xml']
    end

    it 'can convert self to text' do
      array.to_text.must_equal item['expected_as_text']
    end

    it 'can convert self to json' do
      array.to_json.must_equal item['expected_as_json']
    end

    it 'can convert self to yaml' do
      array.to_yaml.must_equal item['expected_as_yaml']
    end
  end
end

describe JottitTo::CLI do
  it 'text' do
    # make stub with webmock
    stub_request(:get, 'example.com').to_return(body: html_of_fixture)

    old_stdout = $stdout
    begin
      $stdout = StringIO.new
      cli = JottitTo::CLI.new
      cli.invoke(:text, ['http://example.com/'])

      $stdout.rewind
      $stdout.read.must_equal "foo\nbar\nbuzz\npiyo\n"
    ensure
      $stdout = old_stdout
    end
  end
end

describe 'bin/' do
  it 'works run(help)' do
    io = IO.popen([
      File.join(File.dirname(__FILE__), '../bin/jottit-to'),
      err: [:child, :out]])
    io.read.must_match(/Commands:/)
  end
end
