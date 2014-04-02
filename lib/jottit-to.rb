#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'thor'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'yaml'
require 'builder'

module JottitTo
  class CLI < Thor
    map '-t' => :text, '-j' => :json, '-y' => :yaml, 'yml' => :yaml

    desc 'text URI', 'Show as text'
    def text(uri)
      puts JottitTo.parse_uri(uri).to_a
    end

    desc 'json URI', 'Show as json'
    def json(uri)
      puts JottitTo.parse_uri(uri).to_json
    end

    desc 'yaml URI', 'Show as yaml'
    def yaml(uri)
      puts JottitTo.parse_uri(uri).to_yaml
    end

    desc 'xml URI', 'Show as xml'
    def xml(uri)
      puts JottitTo.parse_uri(uri).to_xml
    end

    desc 'version', 'Show version'
    map '-v' => :version
    def version
      require_relative './jottit/version'
      say "Jottit-to #{JottitTo::VERSION}"
    end
  end


  class << self
    # e.g. http://youpy.jottit.com/trivia?m=diff&r=525&r=526#fuba =>
    #        http://youpy.jottit.com/trivia
    def normalize_uri(src)
      uri = URI(src)
      uri.query = nil
      uri.fragment = nil
      uri.to_s
    end

    # e.g. <div id="content"><ul><li>foo</li><li>bar</li><ul></div> =>
    #         ['foo', 'bar']
    def parse_html(html)
      html = Nokogiri::HTML(html)
      items = html.css('#content>ul>li').map(&:text)
      items.extend JottitTo::ArrayExtender
      items
    end

    # e.g. http://youpy.jottit.com/trivia => ['foo', 'bar']
    def parse_uri(uri)
      html = URI(normalize_uri(uri)).read
      parse_html(html)
    end
  end

  module ArrayExtender
    # e.g. self => "foo\nbar\n"
    def to_text
      self.join("\n")
    end

    # e.g. self => "<?xml version="1.0" encoding="UTF-8"?>
    # <items>
    #   <item>foo</item>
    #   <item>bar</item>
    # </items>"
    def to_xml
      builder = Builder::XmlMarkup.new(:indent=>2)
      builder.instruct! :xml, version: '1.0', encoding: 'UTF-8'
      xml = builder.items{ self.each{|x| builder.item(x) } }
      xml
    end
  end
end


