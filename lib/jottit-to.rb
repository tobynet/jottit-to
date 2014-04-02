#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'thor'
require 'open-uri'
require 'uri'
require 'nokogiri'

module JottitTo
  class CLI < Thor

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
      items
    end
  end
end
